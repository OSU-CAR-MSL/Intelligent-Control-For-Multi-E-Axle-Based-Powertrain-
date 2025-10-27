clc
clear all
dec=1000;
Rs=0.05;
alpha=0.004;
Temps=readtable('Temp Profile.xlsx');
%%
temp3=Temps{:,4};
Rs3=Rs.*(1+alpha.*temp3);
figure
yyaxis right
plot(temp3)
grid on 
xlabel('Time [sec]')
ylabel('Temperature [C]')
yyaxis left
plot(Rs3)
ylabel('Phase Resistance [ohm]')
title('Experimental Profiles of Operating Temperature and Resistance Variation')
%%
Temps=Temps{:,4};
[M,I] =max(Temps);
Temp=Temps(1:I+60,1);
%T = resample(Temp,10,2);
T = resample(Temp,37,2);
T=T(1:length(T)-100);
delta_T=diff(T);
t=0:length(T)-1;
figure
yyaxis left
plot(t(1:600),T(1:600))
grid on 
ylabel('Temperature [C]')
xlabel('Simulation Time')
title('Temperature Profile')
yyaxis right
plot(t(1:600),Rs.*(1+alpha.*T(1:600)))
grid on 
ylabel('Stator Resistance [ohm]')
xlabel('Simulation Time')
title('Phase Resistance variation [ohm]')