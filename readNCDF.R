######################################################
#~~~~~~~~~~~~~~~~~~~RULES~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#The RegionBoundaries.csv must NOT have headers, and #
#MUST be comma seperated, no other Delimiter can be  #
#used.                                               #
######################################################
#~~~~~~~~~~~~~~~~Libraries Used~~~~~~~~~~~~~~~~~~~~~~#
#ggplot2 and its dependencies                        #
#magic and its dependencies                          #
######################################################
#Code begins here
######################################################
readNCDF <- function(ncdflocation){
  Bounds = read.csv("RegionBoundaries.csv")#Import bounds that are to be used
  LATMAX = t(Bounds[ ,"LATMAX"])
  LATMIN = t(Bounds[ ,"LATMIN"])
  LONMAX = t(Bounds[ ,"LONMAX"])
  LONMIN = t(Bounds[ ,"LONMIN"])
  LandRegion = t(Bounds[ ,"lanoce"])
  
  LandMask = read.csv("Landmask.csv")#Import the land mask CSV ~~ Need to check whether orientations are good.
  OceanMask = read.csv("Oceanmask.csv")#Import the Ocean mask CSV

  ncfile = open.ncdf(ncdflocation)#filename will be an input to the function when this si converted to a function
  Temps = get.var.ncdf(ncfile,"tas")
  Temperature = matrix()
  

  resizem <- function(Temps, rows,cols) {
    rs <- round(seq(0, rows-1)/(rows-1) * (nrow(M)-1) +1)
    cs <- round(seq(0, cols-1)/(cols-1) * (ncol(M)-1) +1)
    Temperature[rs, ][, cs]
  }

  
  TemperatureLengthX = nrow(Temperature)
  TemperatureLengthY = ncol(Temperature)
  TemperatureLengthZ = dim(Temps)[3]#Will be easier to do when we have the NCDF imported, we can check the formatting
  BoundsLength = nrow(Bounds)
  AvgTemp = matrix(0,BoundsLength,TemperatureLengthZ)

  AvgTempLength = ncol(AvgTemp)

  for(j in 1:BoundsLength){
    lat_min = Bounds[j,1]
    lat_max = Bounds[j,2]
    lon_min = Bounds[j,3]
    lon_max = Bounds[j,4]
  
    FirstLat = round((TemperatureLengthY/180)*(90+lat_min)+1)
    LastLat = round((TemperatureLengthY/180)*(90+lat_max))
    FirstLon = round((TemperatureLengthX/360)*lon_min + 1)
    LastLon = round((TemperatureLengthX/360)*lon_max)
  
    if(lon_min>lon_max){
      LatLength = LastLat - FirstLat + 1
      LonLength  = (TemperatureLengthX-FirstLon)+LastLon+1
      tas1 = Temperature[FirstLon:TemperatureLengthX,FirstLat:LastLat, ]##Check to make sure that the colon is the right cyntax here. Also have to check to see how it handles the space. If i doesn't hand;e it well then we will use a new matrix and the append the two
      landmask_reg = LandMask[c(FirstLon:end,1:LastLon),FirstLat:LastLat]
      oceanmask_reg = OceanMask[c(FirstLon:end,1:LastLon),FirstLat:LastLat]
    }else{
      LatLength = LastLat - FirstLat
      LonLength = LastLon - FirstLon
      tas1 = Temperature[FirstLon:LastLon,FirstLat:LastLat, ]
      landmask_reg = landmask[FirstLon:LastLon,FirstLat:LastLat]
      oceanmask_reg = oceanmask[FirstLon:LastLon,FirstLat:LastLat]
    }
  
    vect = seq(lat_min,lat_max,LatLength)
    weights = cos(abs(vect)*pi/180)
    weights = t(weights/(sum(weights)))
    weightmatrix = (kronecker(matrix(1,1,LonLength),weights))/LonLength
    weightmatrix = t(weightmatrix)
    landweights = weightmatrix*landmask_reg
    landweights = landweights/(sum(landweights))
    oceanweights = weightmatrix*oceanmask_reg
    oceanweights = oceanweights/(sum(oceanweights))
  
    for(i in 1:AvgTempLength){
      if(j==1){
        AvgTemp[j,i] = sum(weightmatrix*tas1( , ,i))
      }else{
        landtrue = is.element(j,LandRegions)
        if(landtrue==1){
          AvgTemp(j,i) = sum(landweights*tas1( , ,i))
        }else{
          AvgTemp(j,i) = sum(oceanweights*tas1( , ,i))
        }      
      }
    }
  }



  YearlyAvgT1 = matrix(0,BoundsLength,(TemperatureLengthZ/12))
  for(i in 1:(TemperatureLengthZ/12)){
    start = 12*i-11
    finish = 12*i
    YearlyAvgT1[ ,i] = apply(AvgTemp1( ,start:finish),2,mean)
  }
}