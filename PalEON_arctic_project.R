library(neotoma)
<<<<<<< HEAD

#-------------this is a test-hggg-------- download data ----------------------#
=======
print("hello")
#-------------this is a test--------- download data ----------------------#
>>>>>>> 62f092a18d6cec49807c208c052364bbd4b95381

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

print("will there be any conflicts if I work here and you work there")
x <-2
y= 2+x
p=y*9

#---------------------- reformat surface pollen data ----------------------#


surface_pollen_taxons <- pollen_taxons <- list()
surface_pollen_counts <- pollen_counts <- list()

# lat - lon - elev - taxon.list - 
foseq_along(arctic_suface_pollen_data)

arctic_pollen_data[[1]]$dataset$site.data$lat

#---------------------- reformat surface pollen data ----------------------#
# site.name - lat -lon age Alnus Betula Ericales Populus Salix Total

# site.id - lat -lon age Alnus Betula Ericales Populus Salix Total



names(arctic_surface_pollen_data[[1]])
head(arctic_surface_pollen_data[[1]]$taxon.list)
head(arctic_surface_pollen_data[[1]]$counts)
head(arctic_pollen_data[[1]]$dataset$site.data)
head(arctic_pollen_data[[1]]$ecological)


surface_pollen_taxons <- pollen_taxons <- list()
surface_pollen_counts <- pollen_counts <- list()

# lat - lon - elev - taxon.list - 
foseq_along(arctic_surface_pollen_data)

arctic_pollen_data[[1]]$dataset$site.data$lat



n<-c("Alnus", "Betula", "Ericales", "Populus", "Salix")
sites<-names(arctic_surface_pollen_data)
d<-NULL
sites<-print(arctic_surface_pollen_data$Datasets[,c(2:5)])
df<-data.frame(n,sites, d)



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

print("I love camp PalEON!")
print("my change")
