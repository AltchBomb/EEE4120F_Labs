#Imports

import Pkg; Pkg.add("WAV"); Pkg.add("Plots"); Pkg.add("TickTock"); Pkg.add("MTH229"); Pkg.add("SymPy")
using Pkg

using WAV

whiteNoise = (rand(48000)*2).-1
WAV.wavwrite(whiteNoise, "whiteNoise.wav", Fs=4800) #sample freq is 4800Hz

#white noise generator script: 

function createwhiten(n)
    whiten = Vector{Float64}();
    for i in 1:n*48000
        append!(whiten, (rand()*2. - 1));
    end
    return whiten
end

noise = createwhiten(1);
WAV.wavwrite(noise, "white_noise_sound2.wav", Fs=4800);
print("Number of samples: ", length(noise))

using Plots
h = Plots.histogram(noise)
Plots.display(h)
readline() #this will stop the program at this point till you press enter

using TickTock

# comparing the performance of the two approaches to generate white noise.

# Measuring excecution time of rand() generating 10 seconds of white noise:
tick()
whiteNoise = (rand(48000)*2).-1
#WAV.wavwrite(whiteNoise, "whiteNoise_test1_rand().wav", Fs=4800) #sample freq is 4800Hz
#tok()
#x = tok()
print("Time taken for rand() function to execute generating 10 seconds of white noise: ", tok(), "\n")

# Measuring excecution time of rand() generating 20 seconds of white noise:
tick()
whiteNoise = (rand(96000)*2).-1
#WAV.wavwrite(whiteNoise, "whiteNoise_test1_rand().wav", Fs=4800) #sample freq is 4800Hz
#tok()
#x = tok()
print("Time taken for rand() function to execute generating 20 seconds of white noise: ", tok(), "\n")

# Measuring excecution time of rand() generating 30 seconds of white noise:
tick()
whiteNoise = (rand(180000)*2).-1
#WAV.wavwrite(whiteNoise, "whiteNoise_test1_rand().wav", Fs=4800) #sample freq is 4800Hz
#tok()
#x = tok()
print("Time taken for rand() function to execute generating 30 seconds of white noise: ", tok(), "\n")

# Measuring the execution time of createwhiten(n) for n = 10;
tick()
noise = createwhiten(10);
#WAV.wavwrite(noise, "white_noise_sound2_test2_createwhiten.wav", Fs=4800);
#tok()
#y = tok()
print("Time taken for createwhiten(10) function to execute: ", tok(), "\n")

# Measuring the execution time of createwhiten(n) for n = 20;
tick()
noise = createwhiten(20);
#WAV.wavwrite(noise, "white_noise_sound2_test3_createwhiten.wav", Fs=4800);
print("Time taken for createwhiten(20) function to execute: ", tok(), "\n")

# Measuring the execution time of createwhiten(n) for n = 30;
tick()
noise = createwhiten(30);
#WAV.wavwrite(noise, "white_noise_sound2_test4_createwhiten.wav", Fs=4800);
print("Time taken for createwhiten(30) function to execute: ", tok(), "\n")


# Implement the Pearson’s correlation formula a new function call it corr().

function corr(x = Vector{Float64}(), y = Vector{Float}())
    
    #Setting up summation of xy:
    xyVal = 0
    for i in 1:length(x)
        #xyVal = 0;
        for z in 1:length(y)
            xyVal = xyVal + x[z]*y[z]
        end
        #return xyVal
    end 
    
    #Setting up summation of x values:
    for n in 1:length(x)
        xVal = 0;
        for j in 1:length(x)
            xVal = xVal + x[j]
        end
        #return xVal
    end
    
    #Setting up the summation of y values:
    for c in 1:length(y)
        yVal = 0;
        for p in 1:length(y)
            yVal = yVal + y[p]
        end
        #return yVal
    end   
    
    #Setting up summation of x^2
    x2Val = 0
    for q in 1:length(x)
        #x2Val = 0;
        for g in 1:length(x)
            x2Val = x2Val + x[g]*x[g]
        end
        #return x2Val
    end
    
    #Setting up summation of y^2
    y2Val = 0
    for h in 1:length(y)
        #y2Val = 0;
        for w in 1:length(y)
            y2Val = y2Val + y[w]*y[w]
        end
        #return y2Val
    end
    
    r = xyVal/(sqrt(x2Val)*sqrt(y2Val));
    return r
    
end

corr([1,2,3], [4,5,6])

# Using your output from the createWhiten(numberOfSeconds) function compare its 
# correlation against itself using your correlation function and the Statistics.cor function.

using Statistics

#Correlation of createwhiten() against itself using the corr() function created.
corr(createwhiten(1), createwhiten(1))

#Correlation of creatwhiten() against itself using the Statistics.cor function 
cor(createwhiten(1), createwhiten(1))

noise1 = createwhiten(1);
print("Number of samples: ", length((rand(48000)*2).-1), "\n")
print("Number of samples: ", length(noise1), "\n")
cor((rand(48000)*2).-1, createwhiten(1))

using Base 
using MTH229
using Plots
using SymPy

#defining  variables used
#time
t=0:0.01:1 #100 samples
u=0:0.005:1 #200 samples used to plot and 
#angular frequency
freq1=20*pi
freq2=50*2pi
freq3=2*pi
#empty array for correlation coefficients
k=zeros(0)

#Correlation coefficient vs shift, f = 20 Hz
for i in 0:0.005:1
    f(t)=sin.(freq1*(t))
    #shifted function 
    g(t)=sin.(freq1*(t.-i))
    push!(k,cor(g(t),f(t)))
end 

plot(u,k, 
title="Corelation Coefficient vs shift, f= 20 Hz",
label=false,
lw=2,
xlabel= "Shift",
ylabel= "Correlation Coefficient")

#plot of graph and shifted graphs from above 
f(t)= sin.(freq1*(t))
g(t)=sin.(freq1*(t).-pi/2)
i(t)=sin.(freq1*(t).-pi)
plot(t,f(t),
title="Graph displaying normal and shifted plots",
label=true,
lw=2,
xlabel= "t",
ylabel= "Ampltude",
)
plot!(t,g(t))
plot!(t,i(t))

#Correlation coefficient vs shift, f = 2 Hz
h=zeros(0)
for i in 0:0.005:1
    f(t)=sin.(freq3*(t))
    #shifted function 
    g(t)=sin.(freq3*(t.-i))
    push!(h,cor(g(t),f(t)))
end 
plot(u,h ,
title="Corelation Coefficient vs shift, f= 2 Hz",
label=false,
lw=2,
xlabel= "Shift in time",
ylabel= "Correlation Coefficient")



#Correlation coefficient vs shift, f = 50 Hz
l=zeros(0)
t=0:0.001:1 #1000 samples
u=0:0.001:1 #200 samples used to plot and 
for i in 0:0.001:1
    f(t)=sin.(freq2*(t))
    #shifted function 
    g(t)=sin.(freq2*(t.-i))
    push!(l,cor(g(t),f(t)))
end 
plot(u,l ,
title="Corelation Coefficient vs shift, f= 50 Hz",
label=false,
lw=2,
xlabel= "Shift in time",
ylabel= "Correlation Coefficient")


