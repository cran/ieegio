## ----setup, include = FALSE, echo = FALSE, results='hide'---------------------
# Sys.setenv("IEEGIO_PKGDOWN" = "TRUE")
if (identical(Sys.getenv("IEEGIO_PKGDOWN", unset = ""), "")) {
  knitr::opts_chunk$set(
    collapse = TRUE,
    comment = "#>",
    eval = FALSE
  )
} else {
  knitr::opts_chunk$set(
    collapse = TRUE,
    comment = "#>"
  )
  cache_dir <- tools::R_user_dir("ieegio", "cache")
  dir.create(cache_dir, showWarnings = FALSE, recursive = TRUE)
  cache_dir <- normalizePath(cache_dir, mustWork = TRUE)
  options("ieegio.extract_path", cache_dir)
}

## ----sample-------------------------------------------------------------------
# library(ieegio)
# edf_path <- ieegio_sample_data("edfPlusD.edf")

## ----read_edf-----------------------------------------------------------------
# edf <- read_edf(edf_path, verbose = FALSE)
# print(edf)

## ----edf_methods--------------------------------------------------------------
# header <- edf$get_header()
# str(header)
# 
# chan_tbl <- edf$get_channel_table()
# print(chan_tbl, nrows = 2, topn = 2)
# 
# annot <- edf$get_annotations()
# annot

## ----get_channel--------------------------------------------------------------
# # get Channel 1
# channel <- edf$get_channel(1)
# channel

## ----get_channel_label--------------------------------------------------------
# edf$get_channel("squarewave")

## ----plot_channel-------------------------------------------------------------
# plot(
#   x = channel$time, y = channel$value,
#   xlab = "Time", ylab = channel$info$Unit,
#   main = channel$info$Label,
#   type = "p", pch = ".", col = "green", lwd = 2
# )

## ----write_edf----------------------------------------------------------------
# signal <- sin(seq(0, 10, by = 0.01))
# 
# channels <- list(
#   as_edf_channel(signal, channel_num = 1,
#                  sample_rate = 200, label = "sine"),
# 
#   as_edf_channel(
#     data.frame(
#       timestamp = c(0, 5),
#       comments = c("start", "end")
#     ),
#     channel_num = 2
#   )
# )
# 
# out_path <- tempfile(fileext = ".edf")
# write_edf(channels = channels, con = out_path)

## ----write_edf_verify---------------------------------------------------------
# written <- read_edf(out_path, extract_path = tempfile(), verbose = FALSE)
# written$get_channel("sine")
# written$get_annotations()

## ----write_edf_cleanup, echo = FALSE, results='hide'--------------------------
# written$delete()
# unlink(out_path)

## ----teardown, echo=FALSE, results='hide'-------------------------------------
# cache_dir <- tools::R_user_dir("ieegio", "cache")
# if (file.exists(cache_dir)) {
#   unlink(cache_dir, recursive = TRUE, force = TRUE)
# }

