
#' Apply Threshold Window Algorithm
#'
#' @description
#' Identifies the largest increase or decrease relative to the first
#' observation in a window of sequential data. If the absolute change
#' exceeds the specified threshold, returns the corresponding maximum
#' or minimum value. Otherwise, returns the first observation.
#'
#' @param x A numeric vector containing observations within a window.
#' @param threshold A non-negative numeric value. The output changes
#'   only when the absolute change exceeds this threshold.
#'
#' @return A single numeric value representing the threshold-filtered
#'   observation.
#'
#' @examples
#' window_threshold(c(1, 2, 3), threshold = 0.5)
#' window_threshold(c(1, 1.1, 1.2), threshold = 0.5)
#'
#' @export
window_threshold <- function(x, threshold) {

  increase <- max(x) - x[1]
  decrease <- min(x) - x[1]

  if (increase >= abs(decrease)) {
    change <- increase
  } else {
    change <- decrease
  }

  if (abs(change) > threshold) {
    return(x[1] + change)
  }

  return(x[1])
}


#' Apply Binary Window Algorithm
#'
#' @description
#' Compares the largest increase and decrease relative
#' to the first observation in a window of sequential data. Returns 1 if the increase is
#' larger, -1 if the decrease is larger, and 0 if they are equal.
#'
#' @param x A numeric vector containing observations within a window.
#'
#' @return A single numeric value: 1 for a larger increase, -1 for a
#'   larger decrease, or 0 when the changes are equal.
#'
#' @examples
#' window_binary(c(1, 2, 3))
#' window_binary(c(3, 2, 1))
#' window_binary(c(2, 1, 3))
#'
#' @export
window_binary <- function(x) {

  increase <- max(x) - x[1]
  decrease <- x[1] - min(x)

  if (increase > decrease) return(1)
  if (decrease > increase) return(-1)

  return(0)
}


#' Apply Sliding Window Algorithms
#'
#' @description
#' Applies one or both sliding window algorithms to the acceleration
#' column of a data frame. The results are stored in new columns named
#' `threshold` and/or `binary`.
#'
#' @param data A data frame containing an `acceleration` column.
#' @param window_size A positive integer specifying the number of
#'   observations in each window.
#' @param window_function A character vector specifying which algorithms
#'   to apply. Options are `"threshold"` and `"binary"`.
#' @param threshold A non-negative numeric value. The threshold algorithm
#'   changes the output only when the acceleration change exceeds this value.
#'   Required when `"threshold"` is selected.
#'
#' @return A data frame with additional columns containing the results
#'   of the selected sliding window algorithms. The final
#'   `window_size - 1` observations contain `NA` for newly computed results.
#'
#'#'#' @details
#' The acceleration column must contain only finite numeric values.
#' Missing values must be handled before applying the algorithms.
#'
#' @examples
#' data <- data.frame(acceleration = c(1, 2, 3, 2, 1, 4))
#'
#' apply_window(data, 3, "binary")
#'
#' apply_window(data, 3, "threshold", threshold = 0.5)
#'
#' apply_window(data, 3, c("threshold", "binary"), threshold = 0.5)
#'
#' @export
apply_window <- function(data, window_size, window_function, threshold = NULL) {

  n <- nrow(data)

  if (length(window_size) != 1 ||
      !is.numeric(window_size) ||
      is.na(window_size) ||
      !is.finite(window_size) ||
      window_size < 1 ||
      window_size > n ||
      window_size != floor(window_size)) {
    stop("Window size must be a positive integer not exceeding the number of observations.")
  }

  if (!"acceleration" %in% names(data)) {
    stop("Data must contain an 'acceleration' column.")
  }

  if (!is.numeric(data$acceleration) ||
      any(!is.finite(data$acceleration))) {
    stop("The acceleration column must contain only finite numeric values.")
  }

  if (length(window_function) == 0 ||
      anyNA(window_function) ||
      !is.character(window_function) ||
      !all(window_function %in% c("threshold", "binary"))) {
    stop("window_function must be 'threshold', 'binary', or both.")
  }

  if ("threshold" %in% window_function) {
    if (length(threshold) != 1 ||
        !is.numeric(threshold) ||
        is.na(threshold) ||
        !is.finite(threshold) ||
        threshold < 0) {
      stop("A non-negative numeric threshold must be provided.")
    }
  }

  for (fun in unique(window_function)) {

    data[[fun]] <- NA_real_

    for (i in seq_len(n - window_size + 1)) {

      window <- data$acceleration[i:(i + window_size - 1)]

      if (fun == "threshold") {
        data[[fun]][i] <- window_threshold(window, threshold)
      } else {
        data[[fun]][i] <- window_binary(window)
      }
    }
  }

  return(data)
}
