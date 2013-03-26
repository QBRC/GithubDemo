library(testthat)

#' Expect that x is numeric
square <- function(x){
	x^2		
}

test_that("Square function works on various input types", {
	expect_that(square(3), equals(9))
	expect_that(square(5), equals(25))	
  expect_that(square(2.5), equals(6.25))
  expect_that(square(-2), equals(4))
})

