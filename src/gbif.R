#gbif.R
# query species occurenece data from GBIF
# clean up data
# save it to a csv file
# create a map to display the species occurence points

#list of packages
packages<-c("tidyverse", "rgbif", "usethis", "CoordinateCleaner", "leaflet", "mapview")

# install packages not yet installed
installed_packages<-packages %in% rownames(installed.packages())
if(any(installed_packages==FALSE)){
  install.packages(packages[!installed_packages])
}

# Packages loading, with library function
invisible(lapply(packages, library, character.only=TRUE))

usethis:: edit_r_environ()

spiderBackbone<-name_backbone(name="Habronattus americanus")
speciesKey<-spiderBackbone$usageKey

occ_download(pred("taxonKey",speciesKey), format = "SIMPLE_CSV")

write_csv(d, "data/rawData.csv")

#cleaning

fData <- d %>%
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude))

fData <- fData %>%
  filter(countryCode %in% c("US", "CA", "MX"))

fData <- fData %>%
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LVING_SPECIMEN"))

fData<- fData %>%
  cc_sea(lon="decimalLongitude", lat = "decimalLatitude")
