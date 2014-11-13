context("input")

test_that("wrong input", {
  x = getData()
  expect_error(calcMRMR(x$time[1:2], x$status, x$x), "length")
  expect_error(calcMRMR(x$time, x$status, x$x[1:10, ]), "rows")
  expect_error(calcMRMR(x$time, rep(FALSE, length(x$status)), x$x), "events")
  expect_error(calcMRMR(x$time, x$status, x$x, nselect = -1), ">= 0")
  expect_equal(calcMRMR(x$time, x$status, x$x, nselect = 0), numeric(0))
  expect_error(calcMRMR(x$time, x$status, x$x, nselect = 1000), "<=")
})