library(testthat)

square <- function(x){
	sq <- 0
	for (i in 1:x){
		sq <- sq + x
	}
	return(sq)	
}

test_that("Square function works on various input types", {
	expect_that(square(3), equals(9))
	expect_that(square(5), equals(25))	
})

