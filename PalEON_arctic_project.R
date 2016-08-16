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

