library(neotoma)

#---------------------- download data ----------------------#

# get arctic sites pollen datasets
# surface sample
arctic_suface_pollen_sites <- get_dataset(datasettype = "pollen surface sample", loc=c(-170, 66, -135, 72))
# pollen
arctic_pollen_sites <- get_dataset(datasettype = "pollen", loc=c(-170, 66, -135, 72))

print(arctic_suface_pollen_sites)
print(arctic_pollen_sites)

# download arctic pollen data
arctic_suface_pollen_data <- get_download(arctic_suface_pollen_sites)
arctic_pollen_data <- get_download(arctic_pollen_sites)

print(arctic_suface_pollen_data)
print(arctic_pollen_data)

#---------------------- read shrub map ----------------------#

library(raster)

# locate the dataset in your computer
# setwd("../../PalEON_Arctic_Project/data")
imported_image <- raster("AllShrubMap_masked.img")
projection(imported_image)

#crop the raster a little bit to make it more managable
e <- extent(0, 450000, 2000000, 2300000)
imported_image_cr <- crop(imported_image, e)
plot(imported_image_cr)

# according to the internets this is how you get lon-lat-data matrix
# Convert raster to SpatialPointsDataFrame
shrub_data <- rasterToPoints(imported_image_cr, spatial=TRUE)

# reproject sp object to lat-lon
shrub_data <- spTransform(shrub_data, CRS("+init=epsg:4326"))
proj4string(shrub_data)

# Assign coordinates to @data slot, display first 6 rows of data.frame
shrub_data@data <- data.frame(shrub_data@data, long=coordinates(shrub_data)[,1],
                              lat=coordinates(shrub_data)[,2])                         
head(shrub_data@data)


#---------------------- reformat surface pollen data ----------------------#

names(arctic_suface_pollen_data[[1]])
head(arctic_suface_pollen_data[[1]]$taxon.list)
head(arctic_suface_pollen_data[[1]]$counts)
head(arctic_pollen_data[[1]]$dataset$site.data)


surface_pollen_taxons <- pollen_taxons <- list()
surface_pollen_counts <- pollen_counts <- list()

# lat - lon - elev - taxon.list - 
foseq_along(arctic_suface_pollen_data)

arctic_pollen_data[[1]]$dataset$site.data$lat

