clear; clc; 
fname = 'GliderAD2CP_Data.nc';
ncvarI = ncinfo(fname);
time1 = ncread(fname,'/Environment/time1'); 
sspeed  = ncread(fname,'Environment/sound_speed_indicative');
pressure=ncread(fname,'/Environment/pressure');
heading = ncread(fname,'/Platform/heading');
roll = ncread(fname,'/Platform/roll');
pitch = ncread(fname,'/Platform/pitch');

% (4 beams, 30 cells, cell size = 1, 0.2 blanking
vR = ncread(fname,'/Sonar/Beam_group1/velocity_range'); 
rS = double(ncread(fname,'/Sonar/Beam_group1/range_sample')); %blanking distance so first measurement is 1.2 m from glider
tp = ncread(fname,'/Sonar/Beam_group1/ping_time');
Am = ncread(fname,'/Sonar/Beam_group1/amplitude');
Vm = ncread(fname,'/Sonar/Beam_group1/velocity');
Cr = double(ncread(fname,'/Sonar/Beam_group1/correlation'));


% interpolate pressure
pB = interp1(time1,pressure,tp);
pP = interp1(time1,pitch,tp);
tp = tp-tp(1);

[~,Yz] = meshgrid(pB,rS);
[Y_pitch,~]=meshgrid(pP,rS);

pB(pB<5)=NaN;
Yz = pB' + Yz; % horizontal coordinate of amplitude
[Xz,~] = meshgrid(tp,rS);

N = length(rS); 
M = length(tp);
Vm1 = Vm(:,1,:); % select 1 beam
Cr1 = Cr(:,1,:);
Am1 = Am(:,1,:);

Vm1 = reshape(Vm1,N,M);
Cr1 = reshape(Cr1,N,M);
Am1 = reshape(Am1,N,M);

id = Am1<25 | Am1>75 | abs(Y_pitch)<15 | Cr1<20;
Vm1(id)=NaN;
% 

pcolor(Xz,-Yz,Vm1); shading flat; colorbar;
title('plot of Beam 1 Velocity over time and pressure for cells')
ylabel('pressure (dbar)')
xlabel('ping time in seconds?')
