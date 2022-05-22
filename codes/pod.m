% Snapshot POD driver function
% Follows 3.5-3.6 of citrini and george.
%
function pod()

% function takes in fluctuation with azimuthal and streamwise fft applied.
% that 'looks' like essentially a correlation in time t direction.

% import data object.
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
   % for c = ncs:ncs  % crosssection
        saveStr=[saveDir 'Ravg_r[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
        qq=open(saveStr);
        Rmat_avg=qq.Rmat_avg ; % Rmat(time).cs(cs).circle(=azimuthalSetSize1:18)
        clear qq;
        sprintf('%s','dbg')

% organize this by time at the end, do trapz. then do eig.
% There should be a nxn matrix...


end % fc
