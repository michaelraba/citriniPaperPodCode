% Snapshot POD driver function
% Follows 3.5-3.6 of citrini and george.
%
function pod(fftTransformedFluctuation)
%function pod()

figure(1);
hold on;
% function takes in fluctuation with azimuthal and streamwise fft applied.
% that 'looks' like essentially a correlation in time t direction.

% import data object.
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
   % for c = ncs:ncs  % crosssection
        %saveStr=[saveDir 'Ravg_r[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
        saveStr=[saveDir 'corrMatFuckYeah[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];

        qq=open(saveStr);
        %Rmat_avg=qq.Rmat_avg ; % Rmat(time).cs(cs).circle(=azimuthalSetSize1:18)
        Rmat_avg=qq.corrMatFuckYeah; % Rmat(time).cs(cs).circle(=azimuthalSetSize1:18)
        clear qq;
        sprintf('%s','dbg')
 
% organize this by time at the end, do trapz. then do eig.
% There should be a dim(timesteps) matrix... txt' to be precise..
% there should be 2*ntimesteps - 1 from using xcorr on t..
% ^ which check ..
% this 'has' to be a matrix... need covariance matrix.
% See reference: S? Where they form a _matrix_ for homogeneous data from
% the cross-correlation _function_

% form cc matrix:
        % for each crosssection c, and circle m

for cc=1:ncs % streamwise mode % cannot exceed 1... 
for mm=1:azimuthalSetSize % azimuthal mode
  % get values from struct  for given cc and mm
%c = zeros(ntimesteps);
% bring into form of cross correlation matrix.
%for ii=1:ntimesteps % cols
%for jj=ii:ntimesteps % rows
%for jj=1:ntimesteps % rows
 % not necessary with already symmetric nts x ntes matrix. c(ii,jj) = Rmat_avg(jj).cs(1).circle(mm);
%end % jj
%end % ii
%c = c+ transpose(c) - eye(size(c )).*c; % form symmetric matrix;
% Rmat_avg(18).x(3).dat  
 c = Rmat_avg(mm).x(1).dat;
sprintf('%s','take eigenvals');
% gives eig data for each x-mode and azimutal mode
%[eigVec,eigVal]=eigs(c);
%[eigVec,eigVal]=eigs(c); % sort this.


[eigVec_tmp,eigVal_tmp]=eig(c);
[d,ind] = sort(diag(eigVal_tmp),'descend');
eigVal=eigVal_tmp(ind,ind);
eigVec= eigVec_tmp(:,ind);




% finished with smits2017.eq.2.4

% implement smits2017.eq.2.5:
% for that, we need fft transformed fluctuation at all the t and r's; this is saved in variable...:

%fftTransformedFluctuation(nts,r,ncs)
tTrapz=zeros(ntimesteps,1);
phiVec=zeros(540,1);
for rr=1:540
for tt=1:ntimesteps
  %aa=fftTransformedFluctuation(tt,rr,cc);
  %% fftTransformedFluctuation(18).x(3).dat  % need something with r, leider !!!1 fuck!!
  aa=fftTransformedFluctuation(tt).RadialCircle(rr).azimuth(mm).dat(cc); % t, r , m , c
  bb=ctranspose(eigVec(tt));
  ab = aa*bb;   
  tTrapz(tt) = ab;
  end % tt
ad= trapz(tTrapz);
phiVec(rr) = ad/(eigVal(tt,tt)*ntimesteps); % smits.eq.2.5
end %rr
hold on;
if 1 <= tt < 10
plot(real(phiVec));
end % if 
end % circle mm
end % ncs


end % fc
