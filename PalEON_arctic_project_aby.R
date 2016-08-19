library(neotoma)
library('mapdata')
library(maps)
map("world", c("Alaska"), boundary=TRUE, col=8, add=TRUE, fill=TRUE)
map("state", c("hawaii"), boundary = TRUE, col=8, add = TRUE, fill=TRUE )
#---------------------- download data ----------------------#

# get arctic sites pollen datasets
# surface sample
arctic_surface_pollen_sites <- get_dataset(datasettype = "pollen surface sample", loc=c(-170, 66, -135, 72))
# pollen
arctic_pollen_sites <- get_dataset(datasettype = "pollen", loc=c(-170, 66, -135, 72))

print(arctic_surface_pollen_sites)
print(arctic_pollen_sites)

# download arctic pollen data
arctic_surface_pollen_data <- get_download(arctic_surface_pollen_sites)
arctic_pollen_data <- get_download(arctic_pollen_sites)

print(arctic_surface_pollen_data)
print(arctic_pollen_data)

#---------------------- reformat surface pollen data ----------------------#
# site.name - lat -lon age Alnus Betula Ericales Populus Salix Total

# site.id - lat -lon age Alnus Betula Ericales Populus Salix Total



names(arctic_surface_pollen_data[[1]])
head(arctic_surface_pollen_data[[1]]$taxon.list)
head(arctic_surface_pollen_data[[1]]$counts)
head(arctic_pollen_data[[1]]$counts)
head(arctic_pollen_data[[1]]$ecological)

head(arctic_pollen_data[[39]]$counts)



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

setwd("../PalEON/")

imported_image <- raster("AllShrubMap_masked.img")


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


head(arctic_pollen_data[[39]]$counts)
pollen.id<-arctic_pollen_data[[39]]$counts
pollen.shrub<-rep(NA, 24)
pollen.total<-rep(NA, 24)

pollen.shrub <- apply(pollen.id[,which(colnames(pollen.id)%in% shrub.taxa)],1,sum)
pollen.total<- apply(pollen.id,1,sum)

pollen.all<-data.frame(pollen.id=pollen.id, pollen.shrub=pollen.shrub, pollen.total=pollen.total)
pollen.all$prop<-(pollen.all$pollen.shrub/pollen.all$pollen.total)*100
pollen.all$rownames<-