#' slidingwindows: Sliding Window Algorithms for Sequential Data
#'
#' @description
#' The slidingwindows package provides functions for importing,
#' preparing, analyzing, and visualizing sequential three-dimensional
#' data using sliding window algorithms.
#'
#' The package was developed for accelerometer data but can also
#' be applied to other sequential datasets containing three numeric
#' dimensions and timestamps.
#'
#' @details
#' The typical workflow consists of four steps:
#'
#' 1. Import a CSV file using [import_data()] or load the included
#'    example dataset using [load_example()].
#' 2. Convert timestamps to POSIXct and calculate the Euclidean norm
#'    of three selected columns using [prepare_data()].
#' 3. Apply sliding window algorithms using [apply_window()],
#'    which calls [window_threshold()] and/or [window_binary()].
#' 4. Visualize the original data and the resulting series using
#'    [plot_windows()].
#'
#' The threshold algorithm replaces the first observation of each
#' window with the largest upward or downward deviation when that
#' deviation exceeds a specified threshold.
#'
#' The binary algorithm classifies each window according to whether
#' the largest deviation from its first observation is positive
#' or negative. Tied deviations are assigned a value of zero.
#'
#' @examples
#' data <- load_example()
#' data <- prepare_data(data, x, y, z)
#'
#' data <- apply_window(
#'   data,
#'   window_size = 1000,
#'   window_function = c("threshold", "binary"),
#'   threshold = 0.5
#' )
#'
#' plot_windows(data, time_format = "%H:%M")
#'
#' @seealso
#' [import_data()], [load_example()], [prepare_data()],
#' [window_threshold()], [window_binary()], [apply_window()],
#' [plot_windows()]
#'
"_PACKAGE"
