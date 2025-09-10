# rtmb_tips
tips for (new) RTMB users

## requirements for RTMB functions

* objective function **must be differentiable** with respect to parameters (no `if()`, `abs()`, `round()`, `min()`, `max()` depending on parameters)
* have to implement exotic probability distributions yourself: anything that descends into C(++)/Fortran code will probably fails
* use of `<-[` (see [here](https://groups.google.com/g/tmb-users/c/HlPqkfcCa1g)) etc.
   * specifically, if you use the `c()` function, or if you use the `diag<-` function (which sets the diagonal of a matrix) or the `[<-` function (which assigns values within a matrix), you need to add e.g. `ADoverload("[<-")` to the beginning of your function
* for matrix exponentials, you should use `Matrix::expm()` rather than `expm::expm()`
* RTMB is pickier than R about matrices. You may need to use some combination of `drop()` and `as.matrix()` to convert matrices with dimension 1 in some direction (or `Matrix` matrices) back to vectors
* `[[`-indexing may be much faster than `[`-indexing: see [here](https://groups.google.com/g/tmb-users/c/rm2N5mH8U-8/m/l1sYZov3EAAJ) (and later messages in that thread)
* if you use `cat()` or `print()` to print out numeric values, the results may not make sense (you'll see a printout of RTMB's internal representation of autodiff-augmented numbers ...)

## if transitioning from TMB

* RTMB uses `%*%` (as in base R), not `*` (as in C++) for matrix/matrix and matrix/vector multiplication

## more general points

* data handling (see [here](https://groups.google.com/g/tmb-users/c/sq3y5aTwvjo), [here](https://groups.google.com/g/tmb-users/c/YzSjsHyFYJ8)) (and very similar arguments from 2004 about [MLE fitting machinery taking a `data` argument](https://hypatia.math.ethz.ch/pipermail/r-devel/2004-June/029837.html)
* have to handle prediction, tests, diagnostics, etc. etc. yourself
   * if you do something clever where you define your objective function in a different environment from where you call `MakeADFun`, you can use `assign(..., environment(objective_function))` to make sure that the objective function can see any objects it needs to know about ...
