utils::globalVariables(c("time", "acceleration", "value", "window_function"))

#' Plot Sliding Window Results
#'
#' @description
#' Visualizes the original numeric sequence alongside the results
#' of the sliding window algorithms. Automatically detects whether the
#' threshold and/or binary algorithms have been applied. When both are
#' present, the results are displayed in separate facets.
#'
#' @param data A data frame containing `time`, `acceleration`, and at
#'   least one of the columns `threshold` or `binary`.
#'
#' @param time_format Optional character string specifying the format
#'   of the time axis labels, using POSIXct formatting codes
#'   (e.g., "%H:%M" for hours and minutes or "%M:%S" for
#'   minutes and seconds). Defaults to NULL, which lets
#'   ggplot2 automatically format the time axis.
#'
#' @return A ggplot object showing the original numeric sequence and
#'   the selected sliding window results.
#'
#' @examples
#' data <- load_example()
#' data <- prepare_data(data, x, y, z)
#'
#' data <- apply_window(
#'   data,
#'   window_size = 1000,
#'   window_function = "threshold",
#'   threshold = 0.5
#' )
#'
#' plot_windows(data, time_format = "%H:%M")
#'
#' @export
plot_windows <- function(data, time_format = NULL) {
  if (!all(c("time", "acceleration") %in% names(data))) {
    stop("Data must contain 'time' and 'acceleration' columns. Run prepare_data() first.")
  }

  windows <- intersect(c("threshold", "binary"), names(data))

  if (length(windows) == 0) {
    stop("No window function columns found. Run apply_window() first.")
  }

  plot_data <- do.call(rbind, lapply(windows, function(w) {
    data.frame(
      time = data$time,
      acceleration = data$acceleration,
      value = data[[w]],
      window_function = tools::toTitleCase(w)
    )
  }))

  plot_data$window_function <- factor(plot_data$window_function, levels = tools::toTitleCase(windows))

  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = time)) +
    ggplot2::geom_line(ggplot2::aes(y = acceleration, color = "Original data")) +
    ggplot2::geom_line(ggplot2::aes(y = value, color = window_function), na.rm = TRUE) +
    ggplot2::scale_color_manual(values = c(
      "Original data" = "black",
      "Threshold" = "red",
      "Binary" = "blue"
    )) +
    ggplot2::labs(x = "Time", y = "Value", color = NULL) +
    ggplot2::theme_minimal()

  if (length(windows) == 2) {
    p <- p +
      ggplot2::facet_wrap(~ window_function, scales = "free_y", ncol = 1) +
      ggplot2::labs(title = "Sliding window methods")

  } else {
    p <- p +
      ggplot2::labs(title = paste("Sliding window method:", tools::toTitleCase(windows)))
  }

  if (!is.null(time_format)) {
    p <- p + ggplot2::scale_x_datetime(
      date_labels = time_format
    )
  }

  return(p)
}
