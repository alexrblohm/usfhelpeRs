#' Test Function
#'
#' This is a simple "hello world" type of function
#'
#' @param test_word (str) Add to the test statement
#' @return A str that says it works and the extra
#' @export
#' @examples
#' test("Whoohooo")
test <- function (test_word = ''){
  return(print(paste("It works",test_word)))
}
test("Woo")
