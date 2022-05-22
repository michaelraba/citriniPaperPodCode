% Snapshot POD driver function
% Follows 3.5-3.6 of citrini and george.
%
function pod()

% function takes in fluctuation with azimuthal and streamwise fft applied.
% that 'looks' like essentially a correlation in time t direction.

% import data object.
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
   % for c = ncs:ncs  % crosssection
        saveStr=[saveDir 'avgTimeEnd[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
        qq=open(saveStr);
        avgTimeEnd=qq.avgTimeEnd ;
        clear qq;
        sprintf('%s','dbg')



%end % c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Equation A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% take inner product after multiply each (a,b) by ra and rb , r is radius
% use quad.
% use eig. The return eigvec is the alpha_n , for n eigenvalues.
% use that alpha for eq (B).
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Equation B)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end % fc
