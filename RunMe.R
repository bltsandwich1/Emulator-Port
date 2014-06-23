############################################
#Script that calls the data import function#
############################################
#This scipt puts each NCDF file inteo the  #
#readNCDF function called "readNCDF.r"     #
############################################
#CODE BEGINS HERE                          #
############################################/

source("readNCDF.R")

temperaturesJump = readNCDF('tas_Amon_CCSM4_abrupt4xCO2_r1i1p1_185001-200012.nc')

temperatures30 = readNCDF('tas_Amon_CCSM4_rcp26_r1i1p1_200601-210012.nc')
temperatures45 = readNCDF('tas_Amon_CCSM4_rcp45_r1i1p1_200601-210012.nc')
temperatures60 = readNCDF('tas_Amon_CCSM4_rcp60_r1i1p1_200601-210012.nc')
temperatures85 = readNCDF('tas_Amon_CCSM4_rcp85_r1i1p1_200601-210012.nc')
  
temperaturesHist = readNCDF('tas_Amon_CCSM4_historical_r1i1p1_185001-200512.nc')

temperaturesPI = readNCDF('tas_Amon_CCSM4_piControl_r1i1p1_080001-130012.nc')

temperatures30 = cbind(temperaturesHist[ ,c(1:156)],temperatures30)
temperatures45 = cbind(temperaturesHist[ ,c(1:156)],temperatures45)
temperatures60 = cbind(temperaturesHist[ ,c(1:156)],temperatures60)
temperatures85 = cbind(temperaturesHist[ ,c(1:156)],temperatures85)
