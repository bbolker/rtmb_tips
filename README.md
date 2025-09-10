# rtmb_tips
tips for (new) RTMB users

## requirements for RTMB functions

* objective function **must be differentiable** with respect to parameters (no `if()`, `abs()`, `round()`, `min()`, `max()` depending on parameters)
* have to implement exotic probability distributions yourself: anything that descends into C(++)/Fortran code will probably fails
* use of `<-[` (see [here](https://groups.google.com/g/tmb-users/c/HlPqkfcCa1g)) etc.
   * specifically, if you use the `c()` function, or if you use the `diag<-` function (which sets the diagonal of a matrix) or the `[<-` function (which assigns values within a matrix), you need to add e.g. `ADoverload("[<-")` to the beginning of your function
* You can only "grow" "empty" vectors if initialized with `numeric(0)` not `c()` (i.e. `x <- c(); x[1] <- 2` throws an error, but `x <- numeric(0); x[1] <- 2` does work), see [here](https://groups.google.com/g/tmb-users/c/-MyEk1m0lBo); It is (probably) better practice to avoid "growing" vectors and preallocate instead i.e. `x <- numeric(1); x[1] <- 2`.
* for matrix exponentials, you should use `Matrix::expm()` rather than `expm::expm()`
* RTMB is pickier than R about matrix types. You may need to use some combination of `drop()` and `as.matrix()` to convert matrices with dimension 1 in some direction (or `Matrix` matrices) back to vectors
* `[[`-indexing may be much faster than `[`-indexing: see [here](https://groups.google.com/g/tmb-users/c/rm2N5mH8U-8/m/l1sYZov3EAAJ) (and later messages in that thread)
* if you use `cat()` or `print()` to print out numeric values, the results may not make sense (you'll see a printout of RTMB's internal representation of autodiff-augmented numbers ...)

## if transitioning from TMB

* RTMB uses `%*%` (as in base R), not `*` (as in C++) for matrix/matrix and matrix/vector multiplication

## more general points

* as in C++ code, you probably don't have to worry as much about non-vectorized code (e.g. `for` loops) being very slow relative to vectorized codes: see `vectorization_comp.R` for the code behind this example:
```
Unit: microseconds
         expr   min    lq  mean median    uq  max neval cld
         vect   2.8   3.2   4.3    3.5   3.9  282 10000 a
    vect_RTMB  12.7  13.4  15.0   13.8  14.8  135 10000  b 
      forloop 223.0 240.1 245.0  244.2 248.7  382 10000   c
 forloop_RTMB  12.6  13.5  15.7   13.9  14.8 3835 10000  b 
```
* data handling (see [here](https://groups.google.com/g/tmb-users/c/sq3y5aTwvjo), [here](https://groups.google.com/g/tmb-users/c/YzSjsHyFYJ8)) (and very similar arguments from 2004 about [MLE fitting machinery taking a `data` argument](https://hypatia.math.ethz.ch/pipermail/r-devel/2004-June/029837.html)
* have to handle prediction, tests, diagnostics, etc. etc. yourself
* if you do something clever where you define your objective function in a different environment from where you call `MakeADFun`, you can use `assign(..., environment(objective_function))` to make sure that the objective function can see any objects it needs to know about ...
