#' Load Example Accelerometer Data
#'
#' @description
#' Loads the example accelerometer dataset included with the package.
#' The dataset contains time measurements and three-dimensional
#' sequential data.
#'
#' @return A data frame containing the example accelerometer dataset.
#'
#' @examples
#' data <- load_example()
#'
#' head(data)
#'
#' @export
load_example <- function() {
  file_path <- system.file(
    "extdata",
    "Example_window.csv",
    package = "slidingwindows",
    mustWork = TRUE
  )

  utils::read.csv(file_path)
}
