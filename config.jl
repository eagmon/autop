###
# Configuration
###
include("drawcircle.jl")

fieldSize = 3400 #2400
fieldRes = 50 #40
fieldSizeY = fieldSize
fieldSizeX = fieldSize
fieldResY = fieldRes
fieldResX = fieldRes

timeTotal=500 #100000
stepIntegration=0.5
visInterval=2 #200 #this is for visualization throughout simulation
stepVisualization=5
#visDelay=0.

###
# Stability
###

epsilon = 0.001
stableTime = 5000

###
# initial configuration
###

_xc = fieldSize/2 # circle center's x position
_yc = fieldSize/2 # circle center's y position
_mR = 160 #180 # membraneRadius
_mT = 200 #170  # membraneThickness
_fD = 30 #25 # food refill distance

# adjust membrane for given resolution
xc = ceil(_xc*fieldRes/fieldSize)
yc = ceil(_yc*fieldRes/fieldSize)
mR = ceil(_mR*fieldRes/fieldSize) # membraneRadius
mT = ceil(_mT*fieldRes/fieldSize) # membraneThickness
fD = 2 #ceil(_fD*fieldRes/fieldSize) # membraneThickness

avgM = 0.8 #initial concentration of M in membrane
avgA = 0.6 #0.6
avgF = 0.18
avgT = 0.0

Frefill = zeros(fieldResY, fieldResX)
for r in 0:0.01:(mR+mT+fD)
    drawcircle!(Frefill, xc, yc, r)
end
# for r in 0:0.01:(mR+mT+fD)
#     drawcircle!(Frefill, xc, yc+fieldRes, r)
# end
FrefillBinMask = Frefill .< 0.5


###
#Tear membrane
###
tearTime1 = 10 #10 #timeTotal+1 #concentration tear
tearTime2 = 10 #10 #timeTotal+1 #directionality tear
tearSize1 = 200 #250
tearSize2 = 200 #250


###
# diffusion/repulsion
###

diffusionF = 20 # absolute diffusion rate
diffusionT = 20 # absolute diffusion rate
diffusionA = 20 # absolute diffusion rate
diffusionM = 20 # absolute diffusion rate
diffusionW = 20 # absolute diffusion rate
attractionRate = 0.1 # attraction of directionality

MW_repulsion=7.0 #7.0
MA_repulsion=7.0 #7.0
MM_repulsion=1.5 #2.9 #0.5
AA_repulsion=1.5 #2.9 #1.5 #0.5
# WW_repulsion=0.0

long_direction = 20.0

###
# reaction rules
###

decayA = 0.001 # this is per timestep, not integration step.
decayM = 0.001

# rules for food
flowRateF = 0.8
saturationF = avgF
noiseMean = 0 # noise to F
noiseSD   = 0.01

# reaction 1 : a11*A + f11*F + m11*M + w11*W <-> a12*A + f12*F + m12*M + w12*W
a11=2; f11=1; m11=0; w11=0; # negative numbers inhibit
a12=3; f12=0; m12=0; w12=0; # inhibition needs to balanced for there not to be creation

kf1 = 0.09 #0.1 # forward reaction rate
kb1 = 0.0 # backwards reaction rate

# reaction 2 : a21*A + f21*F + m21*M + w21*W <-> a22*A + f22*F + m22*M + w22*W
a21=2; f21=1; m21=0; w21=0;
a22=2; f22=0; m22=1; w22=0;

kf2=0.1 # forward reaction rate
kb2=0.0 # backwards reaction rate

#reaction 3 : a31*A + f31*F + m31*M + w31*W <-> a32*A + f32*F + m32*M + w32*W
a31=0; f31=0; m31=0; w31=0;
a32=0; f32=0; m32=0; w32=0;

kf3=0.0 # forward reaction rate
kb3=0.0 # backwards reaction rate