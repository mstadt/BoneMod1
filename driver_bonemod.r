# This driver is to run the bone model without any drug dosing

library(deSolve)
library(rootSolve)
library(tidyverse)

source("ca.bone.lib.r")

camod <- ca.bone.load.model()
camod <- ca.bone.derive.init(camod)

# set simulation times
times <- seq(0,500,1)

# initial condition
IC = unlist(camod$init[camod$cmt])

# Steady state solution
print('get SS')
#ST <- stode(IC, time = 0, func = camod$model, parms = camod$param)
# This function runs system of ODEs to SS solution
ST <- runsteady(IC, time = c(0,Inf), func = camod$model, parms = camod$param)
#ST <- steady(IC, time = c(0,Inf), func = camod$model, parms = camod$param)
print(ST$y)
IC <- ST$y

print('Running simulation')
## RUN THE MODEL
out <- as.data.frame(
                    lsoda(
                        IC, 
                        times, 
                        camod$model,
                        camod$param,
                        rtol=1e-10,
                        atol=1E-10,
                        ynames=F
                        )
                    )
print('Simulation finished')