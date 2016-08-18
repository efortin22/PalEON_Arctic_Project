library(neotoma)
<<<<<<< HEAD


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


# Assign coordinates to @data slot, display first 6 rows of data.frame
shrub_data@data <- data.frame(shrub_data@data, long=coordinates(shrub_data)[,1],
                              lat=coordinates(shrub_data)[,2])                         
head(shrub_data@data)


##---------------------Map of Alaska---------------------------------------#
library(maps)
Alaska.map <- map("world", c("USA:Alaska"), xlim=c(-180,-135), ylim=c(50,72),interior = FALSE)
northslope.map <- map("world", c("USA:Alaska"), xlim=c(-170,-135), ylim=c(66,72),interior = FALSE)


#---------------------- reformat surface pollen data ----------------------#


surface_pollen_taxons <- pollen_taxons <- list()
surface_pollen_counts <- pollen_counts <- list()

#---------------------- reformat surface pollen data ----------------------#
# site.name - lat -lon age Alnus Betula Ericales Populus Salix Total

# site.id - lat -lon age Alnus Betula Ericales Populus Salix Total



names(arctic_surface_pollen_data[[1]])
head(arctic_surface_pollen_data[[1]]$taxon.list)
head(arctic_surface_pollen_data[[1]]$counts)
head(arctic_pollen_data[[1]]$dataset$site.data)
head(arctic_pollen_data[[1]]$ecological)
head(arctic_pollen_data[[1]]$taxon.list)


surface_pollen_taxons <- pollen_taxons <- list()
surface_pollen_counts <- pollen_counts <- list()


# site.name - lat -lon age Alnus Betula Ericales Populus Salix Total

sites.id<-names(arctic_surface_pollen_data)
site.lat<- rep(NA, 148)
site.long<-rep(NA, 148)
site.total<-rep(NA,148)
shrub.total <- rep(NA,148)

shrub.taxa <- c("Alnus", "Betula", "Salix" )
for(i in 1:length(arctic_surface_pollen_data)){
  
  site.lat[i]<-arctic_surface_pollen_data[[i]]$dataset$site.data$lat
  site.long[i]<-arctic_surface_pollen_data[[i]]$dataset$site.data$long
  site.total[i]<-sum(arctic_surface_pollen_data[[i]]$count)
  
  shrub.total[i] <- sum(arctic_surface_pollen_data[[i]]$count[which(colnames(arctic_surface_pollen_data[[i]]$counts) %in% shrub.taxa)])
  
}

surface_pollen <- data.frame(site.id = sites.id,site.lat = site.lat, site.long = site.long, site.total = site.total, shrub.total = shrub.total)
surface_pollen$prop<-(surface_pollen$shrub.total/surface_pollen$site.total)*100




print("I love camp PalEON!")
