% This is the code to get P-V-T surface of CO2
% This code generates solid model only for inside the dome region

w = Solution('liquidvapor.cti', 'carbondioxide');
lowtemp=273.15+000;%lowest temperature possible in the dome

set(w,'T',lowtemp);
setState_satLiquid(w);
t=temperature(w);
V=[];%we are only taking 201 values inside the dome
P=[];%we are only taking 201 values inside the dome
T=[];%we are only taking 201 values inside the dome
p=(critTemperature(w)-lowtemp)/100;%to get 100 values of temperature in left side of dome, i am sampling it

%lowest temperature satliquid P,V,T
T(1,1)=t; % Initiating with the liquid water
V(1,1)=1/density(w);
P(1,1)=pressure(w);
setState_satVapor(w);
T(1,2)=t;
V(1,2)=1/density(w);
P(1,2)=pressure(w);
setState_satLiquid(w);
%for left side of dome just before crit Temperature
for i=2:100
    if(t~=critTemperature(w))
        t=t+p;%increasin the temperature to next sample
        set(w,'T',t);
        setState_satLiquid(w);
        T(i,1)=t;
        V(i,1)=1/density(w);
        P(i,1)=pressure(w);      
       
    else
        break;
    end
    
end

%at crit temperature
k=101;%index
t=t+p;
set(w,'T',t);
T(k,1)=t;
V(k,1)=1/density(w);
P(k,1)=pressure(w);
T(k,2)=t;
V(k,2)=1/density(w);
P(k,2)=pressure(w);

%right side of dome after crit temperature (except the least temperature's
%vapor)
t=lowtemp;
for i=2:100
    if(t~=critTemperature(w))
        t=t+p;%increasin the temperature to next sample
        set(w,'T',t);
        setState_satVapor(w);
        T(i,2)=t;
        V(i,2)=1/density(w);
        P(i,2)=pressure(w);      
       
    else
        break;
    end
    
end


T = T/100;
V = V *1000;
P = P/1000000;

Surface = surf(T, V,P);
surf2solid(T, V, P);
stlwrite('PVT-inside-dome.stl', surf2solid(T, V, P));

