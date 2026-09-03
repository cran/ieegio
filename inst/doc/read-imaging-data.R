## ----setup, include=FALSE, echo = FALSE, results='hide'-----------------------
if (identical(Sys.getenv("IEEGIO_PKGDOWN", unset = ""), "")) {
  knitr::opts_chunk$set(
    collapse = TRUE,
    comment = "#>",
    eval = FALSE
  )
} else {
  options("rgl.useNULL" = TRUE)
  library(ieegio)
  library(rgl)
  knitr::opts_chunk$set(
    collapse = TRUE,
    comment = "#>"
  )
  rgl::setupKnitr(autoprint = FALSE)
  cache_dir <- tools::R_user_dir("ieegio", "cache")
  dir.create(cache_dir, showWarnings = FALSE, recursive = TRUE)
  cache_dir <- normalizePath(cache_dir, mustWork = TRUE)
  options("ieegio.extract_path", cache_dir)
}


## ----sample-------------------------------------------------------------------
# library(ieegio)
# 
# # volume file
# nifti_file <- ieegio_sample_data("brain.demosubject.nii.gz")
# 
# # geometry
# geom_file <- ieegio_sample_data(
#   "gifti/icosahedron3d/geometry.gii")
# 
# # measurements
# shape_file <- ieegio_sample_data(
#   "gifti/icosahedron3d/rand.gii"
# )
# 
# # time series
# ts_file <- ieegio_sample_data(
#   "gifti/icosahedron3d/ts.gii")
# 
# # streamlines
# trk_file <- ieegio_sample_data(
#   "streamlines/CNVII_R.trk")
# 
# tck_file <- ieegio_sample_data(
#   "streamlines/CNVII_R.tck")
# 
# tt_file <- ieegio_sample_data(
#   "streamlines/CNVII_R.tt")
# 
# # AFNI/SUMA std.141 geometry and matching annotation
# std141_geom_file <- ieegio_sample_data(
#   "gifti/std.141.lh.inf_200.gii")
# 
# niml_file <- ieegio_sample_data(
#   "niml/std.141.lh.aparc.a2009s.annot.niml.dset")
# 
# # volumetric atlas
# atlas_file <- ieegio_sample_data(
#   "atlases/YBA/YBA690.nii.gz")

## ----read_volume--------------------------------------------------------------
# volume <- read_volume(nifti_file)
# volume

## ----plot_volume, fig.width=8, fig.height=3, out.width="95%"------------------
# par(mfrow = c(1, 3), mar = c(0, 0, 3.1, 0))
# 
# ras_position <- c(-50, -10, 15)
# 
# ras_str <- paste(sprintf("%.0f", ras_position), collapse = ",")
# 
# for (which in c("coronal", "axial", "sagittal")) {
#   plot(x = volume, position = ras_position, crosshair_gap = 10,
#        crosshair_lty = 2, zoom = 3, which = which,
#        main = sprintf("%s T1RAS=[%s]", which, ras_str))
# }
# 

## ----read_surface-------------------------------------------------------------
# library(ieegio)
# # geometry
# geometry <- read_surface(geom_file)
# 
# # measurements
# measurement <- read_surface(shape_file)
# 
# # time series
# time_series <- read_surface(ts_file)

## ----merge--------------------------------------------------------------------
# merged <- merge(geometry, measurement, time_series)
# print(merged)

## ----plot_surface, webgl = TRUE, out.width="70%", fig.width = 7---------------
# # plot the first column in measurements section
# plot(merged, name = list("measurements", 1))

## ----time_series, webgl = TRUE, out.width="100%", fig.width = 7---------------
# ts_demean <- apply(
#   merged$time_series$value,
#   MARGIN = 1L,
#   FUN = function(x) {
#     x - mean(x)
#   }
# )
# merged$time_series$value <- t(ts_demean)
# plot(
#   merged, name = "time_series",
#   col = c(
#     "#053061", "#2166ac", "#4393c3",
#     "#92c5de", "#d1e5f0", "#ffffff",
#     "#fddbc7", "#f4a582", "#d6604d",
#     "#b2182b", "#67001f"
#   )
# )

## ----read_streamlines, results='hide'-----------------------------------------
# trk <- read_streamlines(trk_file, half_voxel_offset = TRUE)
# tck <- read_streamlines(tck_file)
# tt <- read_streamlines(tt_file)

## ----streamline_subset--------------------------------------------------------
# message("Total number of streamlines: ", length(trk))
# 
# head(trk[[1]]$coords)

## ----streamline_plot, out.width="100%", fig.width = 9, fig.height=3-----------
# pal <- colorRampPalette(c("navy", "grey", "red"))
# plot(trk, col = pal(length(trk)))

## ----streamline_write---------------------------------------------------------
# # Create a temporary file
# tfile <- tempfile(fileext = ".trk")
# write_streamlines(x = tck, con = tfile)

## ----streamline_cleanup, echo = FALSE, results='hide'-------------------------
# if (file.exists(tfile)) {
#   unlink(tfile)
# }

## ----read_niml----------------------------------------------------------------
# std141_geometry <- read_surface(std141_geom_file)
# 
# annotation <- read_surface(niml_file)
# annotation

## ----merge_niml---------------------------------------------------------------
# labeled <- merge(std141_geometry, annotation)
# labeled

## ----plot_niml, fig.width=7, fig.height=4, out.width="95%"--------------------
# plot(labeled, name = "annotations")

## ----roi_describe-------------------------------------------------------------
# atlas <- read_volume(atlas_file)
# 
# # describe: which voxels count as the region
# roi <- as_ieegio_roi(atlas, threshold_lb = 1, threshold_ub = 5)
# roi

## ----roi_resolve--------------------------------------------------------------
# # compute: turn that description into geometry
# resolve_roi_as(roi, "pointcloud")

## ----roi_overlap--------------------------------------------------------------
# overlap <- detect_roi_overlap(
#   as_ieegio_roi(atlas, threshold_lb = 1),
#   trk,
#   radius = 2
# )
# overlap

## ----volume_to_surface--------------------------------------------------------
# volume_to_surface(atlas, threshold_lb = 1, threshold_ub = 5)

## ----spaces-------------------------------------------------------------------
# mni <- new_space("MNI152", orientation = "RAS")
# mni
# 
# surface_to_surface(
#   geometry,
#   space_from = "scanner",
#   space_to = mni,
#   transform = diag(1, 4)
# )

## ----teardown, echo=FALSE, results='hide'-------------------------------------
# cache_dir <- tools::R_user_dir("ieegio", "cache")
# if (file.exists(cache_dir)) {
#   unlink(cache_dir, recursive = TRUE, force = TRUE)
# }

