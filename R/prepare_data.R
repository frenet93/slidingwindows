#' Prepare Three-Dimensional Sequential Data
#'
#' @description
#' Converts timestamps to POSIXct and calculates the Euclidean norm
#' of three numeric variables in sequential data.
#'
#' @param data A data frame containing timestamps and three numeric variables.
#' @param x Name or index of the first numeric variable.
#' @param y Name or index of the second numeric variable.
#' @param z Name or index of the third numeric variable.
#'
#' @details
#' The function can be applied to any sequential dataset containing
#' three numeric variables, such as accelerometer measurements or
#' three-dimensional position data.
#'
#' Variables can be specified using unquoted column names, quoted
#' column names, or numeric column indices. Their names in the
#' dataset do not matter.
#'
#' The input data must contain a column named `time`. Numeric timestamps
#' are interpreted as seconds since the Unix epoch (1970-01-01 UTC).
#' Character timestamps, dates, and POSIXt objects are also supported.
#'
#' The Euclidean norm is calculated for each observation and stored
#' in a new column named `acceleration`. Missing values in the
#' selected variables result in missing Euclidean norms.
#'
#' @return A data frame containing the original variables, a `time`
#'   column converted to POSIXct, and a new numeric `acceleration` column.
#'
#' @examples
#' data <- data.frame(
#'   time = 0:4,
#'   horizontal = 1:5,
#'   vertical = 2:6,
#'   lateral = 3:7
#' )
#'
#' prepare_data(data, horizontal, vertical, lateral)
#' prepare_data(data, "horizontal", "vertical", "lateral")
#' prepare_data(data, 2, 3, 4)
#'
#' @export
prepare_data <- function(data, x, y, z) {

  if (!is.data.frame(data)) {
    stop("Input must be a data frame.")
  }

  resolve_column <- function(expr) {
    if (is.symbol(expr)) {
      return(as.character(expr))
    }
    if (is.character(expr) || is.numeric(expr)) {
      return(expr)
    }
    eval(expr, envir = parent.frame(2))
  }

  columns <- c(
    resolve_column(substitute(x)),
    resolve_column(substitute(y)),
    resolve_column(substitute(z))
  )

  if (is.character(columns)) {
    if (anyNA(columns) || !all(columns %in% names(data))) {
      stop("One or more selected columns do not exist.")
    }
  } else if (is.numeric(columns)) {
    if (anyNA(columns) ||
        any(!is.finite(columns)) ||
        any(columns != floor(columns)) ||
        any(columns < 1 | columns > ncol(data))) {
      stop("One or more selected column indices are invalid.")
    }
  } else {
    stop("Columns must be specified by names or numeric indices.")
  }

  if (!all(vapply(data[columns], is.numeric, logical(1)))) {
    stop("The selected columns must contain numeric values.")
  }

  if (!"time" %in% names(data)) {
    stop("The dataset must contain a 'time' column.")
  }

  if (is.numeric(data$time)) {

    data$time <- as.POSIXct(
      data$time,
      origin = "1970-01-01",
      tz = "UTC"
    )

  } else if (inherits(data$time, "POSIXt")) {

    data$time <- as.POSIXct(data$time)

  } else if (inherits(data$time, "Date")) {

    data$time <- as.POSIXct(data$time, tz = "UTC")

  } else if (is.character(data$time) ||
             is.factor(data$time)) {

    data$time <- as.POSIXct(
      as.character(data$time),
      tryFormats = c(
        "%Y-%m-%d %H:%M:%OS",
        "%Y/%m/%d %H:%M:%OS",
        "%d/%m/%Y %H:%M:%OS",
        "%Y-%m-%d",
        "%Y/%m/%d"
      ),
      tz = "UTC"
    )

  } else {
    stop("Unsupported timestamp format.")
  }

  if (anyNA(data$time)) {
    warning("Missing or invalid values in the time variable.")
  }

  data$acceleration <- sqrt(
    data[[columns[1]]]^2 +
      data[[columns[2]]]^2 +
      data[[columns[3]]]^2
  )

  if (anyNA(data$acceleration)) {
    warning(
      "Missing values in the selected variables have produced missing Euclidean norms."
    )
  }

  return(data)
}
