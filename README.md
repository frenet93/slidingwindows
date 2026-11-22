# slidingwindows

An R package for applying sliding window algorithms to sequential three-dimensional data.

The package was developed using accelerometer data but can be applied to other sequential datasets containing three numeric dimensions and timestamps.

## Features

- Import sequential data from CSV files.
- Convert timestamps to POSIXct and calculate the Euclidean norm of three selected columns.
- Apply threshold-based and binary sliding window algorithms.
- Visualize the original numeric sequence alongside the results using `ggplot2`.

## Installation

Install the development version from GitHub:

```r
# install.packages("remotes")
remotes::install_github("frenet93/slidingwindows")
```

## Example

The package includes an example accelerometer dataset.

```r
library(slidingwindows)

# Load example data
data <- load_example()

# Convert timestamps and calculate the Euclidean norm
data <- prepare_data(data, x, y, z)

# Apply the threshold algorithm
data <- apply_window(
  data,
  window_size = 1000,
  window_function = "threshold",
  threshold = 0.5
)

# Visualize the results
plot_windows(data, time_format = "%H:%M")
```

To apply both algorithms:

```r
data <- apply_window(
  data,
  window_size = 1000,
  window_function = c("threshold", "binary"),
  threshold = 0.5
)

plot_windows(data, time_format = "%H:%M")
```

The `time_format` argument is optional. When omitted, `ggplot2` automatically formats the time axis.

## Sliding window algorithms

**Threshold algorithm (`window_threshold()`)**

For each window, the algorithm identifies the largest positive or negative deviation from its first observation. If the absolute deviation exceeds the specified threshold, the corresponding extreme value is returned. Otherwise, the first observation is retained.

**Binary algorithm (`window_binary()`)**

For each window, the algorithm compares the largest positive and negative deviations from its first observation and returns:

- `1` if the positive deviation is larger.
- `-1` if the negative deviation is larger.
- `0` if the deviations are equal.

The window size specifies the number of observations included in each window. Windows advance by one observation, and the final observations without complete windows receive `NA` values.

## Functions

| Function | Description |
|---|---|
| `import_data()` | Imports a CSV file |
| `load_example()` | Loads the included example dataset |
| `prepare_data()` | Converts timestamps and calculates the Euclidean norm |
| `window_threshold()` | Applies the threshold algorithm to a numeric vector |
| `window_binary()` | Applies the binary algorithm to a numeric vector |
| `apply_window()` | Iteratively applies the selected algorithms |
| `plot_windows()` | Visualizes the original and processed series |

Individual function documentation is available through R's help system, for example `?apply_window` and `?plot_windows`.

## License

MIT License.
