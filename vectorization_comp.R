library(RTMB)
library(microbenchmark)

set.seed(101)
x <- rnorm(1000)
y <- rnorm(1000)
f1_vect <- function(p) {
  sum(x+y)
}

f1_forloop <- function(p) {
  z <- 0
  for (i in seq_along(x)) {
    z = z + x[i] + y[i]
  }
  z
}

f1_vect_RTMB <- MakeADFun(f1_vect, list(p=1))
f1_forloop_RTMB <- MakeADFun(f1_forloop, list(p=1))

mm <- microbenchmark(vect = f1_vect(0),
                     vect_RTMB = f1_vect_RTMB$fn(0),
                     forloop = f1_forloop(0),
                     forloop_RTMB = f1_forloop_RTMB$fn(0),
                     times = 10000L)
                     

library(ggplot2); theme_set(theme_bw())
autoplot(mm) + aes(fill = I("gray"))
