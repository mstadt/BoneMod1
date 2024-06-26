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
IC <- ST$y # make the IC the ST values

camod$model2 <- 

print('Running simulation')
## RUN THE MODEL
out <- as.data.frame(
                    lsoda(
                        IC, 
                        times, 
                        camod$model2,
                        camod$param,
                        rtol=1e-10,
                        atol=1E-10,
                        ynames=F
                        )
                    )
print('Simulation finished')

## POST PROCESSING
out <- ca.bone.responses(out,camod)
# this outputs the model output to a file so that I can later postprocess
# write.csv(out, file = filename) 

#' Plot
print('Plotting results')
ggplot(out) +
  geom_line(aes(x=time,y=ECCPhos)) 
  labs(x="Time (hours)", y="ECCPhos") 

ggsave("eccphos.png",width = 8, height = 4, dpi = 300)


# Plot Calcium
ggplot(out) +
  geom_line(aes(x=time,y=CaConc)) +
  labs(x="Time (hours)", y="Calcium conc")

  ggsave("caconc.png",width = 8, height = 4, dpi = 300)


# Plot PTHconc
ggplot(out) +
  geom_line(aes(x=time,y=PTHconc)) +
  labs(x="Time (hours)", y="PTHconc") 
  ggsave("pthconc.png",width = 8, height = 4, dpi = 300)


# Plot calcitriol
ggplot(out) +
  geom_line(aes(x=time,y=CalcitriolConc)) +
  labs(x="Time (hours)", y="Ctriolconc") 
  ggsave("ctriol.png",width = 8, height = 4, dpi = 300)

print('done!')