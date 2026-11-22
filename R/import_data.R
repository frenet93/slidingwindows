#' Import Accelerometer Data
#'
#' @description
#' Imports a CSV file containing accelerometer measurements into R.
#' Checks that the file exists, has a CSV extension, and contains
#' observations.
#'
#' @param file_path A character string specifying the path to a CSV file.
#'
#' @return A data frame containing the imported data.
#'
#' @examples
#' file_path <- system.file(
#'   "extdata", "Example_window.csv",
#'   package = "slidingwindows"
#' )
#'
#' data <- import_data(file_path)
#'
#' @export
import_data <- function(file_path) {

  if (!file.exists(file_path)) {
    stop("File does not exist: ", file_path)
  }

  if (!grepl("\\.csv$", file_path, ignore.case = TRUE)) {
    stop("Unsupported file format. Please provide a CSV file.")
  }

  data <- tryCatch(
    utils::read.csv(file_path),
    error = function(e) {
      stop("Unable to read CSV file: ", conditionMessage(e))
    }
  )

  if (nrow(data) == 0) {
    stop("The CSV file contains no observations.")
  }

  return(data)
}
