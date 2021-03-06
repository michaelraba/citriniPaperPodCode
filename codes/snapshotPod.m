% Snapshot POD driver function
function [phiVec,phiVecNormalized]=snapshotPod(currentAzimuthalMode,currentCrossSection,currentCorrMat,currentUvec,phiVec,phiVecNormalized   )
%function pod()
%figure(1);


hold on;
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir,csSet,timeSet]=constants();
     % this needs checked   
%saveStr=[saveDir 'corrMatRavg[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
 %       qq=open(saveStr);
       % Rmat_avg=qq.corrMatRavg; % Rmat(time).cs(cs).circle(=azimuthalSetSize1:18)
        clear qq;
        %sprintf('%s','dbg')
%for cc=1:ncs % streamwise mode % cannot exceed 1... 
         % xdirPostFft needs to be correct timebloc.
dr = 9.276438000000004e-04 + zeros(ss,1);
rMat=0:dr:.50001; % [0, ...,0.5] with 540 elements %  needs checked


%for mm=1:azimuthalSetSize % azimuthal mod
% currentCorrMat = Rmat_avg(mm).c(cc).dat; % this is the R(k;m;t,t'). needs to bbe fix for c
sprintf('%s','take eigenvals');
[eigVec_tmp,eigVal_tmp]=eig(currentCorrMat);
[d,ind] = sort(diag(eigVal_tmp),'descend');
eigVal=eigVal_tmp(ind,ind);
eigVec= eigVec_tmp(:,ind);
tTrapz=zeros(ntimesteps,1);
%phiVec=zeros(ss,1);


        %saveStr=[saveDir 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '[TimeBloc]' num2str(timeBloc) '.mat'];
        %uu=open(saveStr);
        %xDirPostFft=qq.xDirPostFft;

for podModeNumber=1:3
for rr=1:ss
for tt=1:ntimesteps % finding the n eigenfunctions Phi^{(n)}(r)...:
    % currentUvec.r(7).dat  
    aa=currentUvec.r(rr).dat(tt); % this indeed varies with t.
    bb=ctranspose(eigVec(podModeNumber)); % this t plays the role of eigvecs \in [0,N]. Should save each separate.
    ab = aa*bb;   
    tTrapz(tt) = ab;
  end % tt
ad= trapz(tTrapz);



phiVec(podModeNumber).c(currentCrossSection).m(currentAzimuthalMode).dat(rr) = ad/(eigVal(tt,tt)*ntimesteps); % smits.eq.2.5
%phiVec(podModeNumber).c(currentCrossSection).m(currentAzimuthalMode).dat(rr) = ad/(eigVal(podModeNumber,podModeNumber)*ntimesteps); % smits.eq.2.5
end %rr

vNormalize = zeros(ss,1);
for nm=1:ss
pV = phiVec(podModeNumber).c(currentCrossSection).m(currentAzimuthalMode).dat(nm);
vNormalize(nm)= rMat(nm)*ctranspose(pV)*pV;
end % nm
normRes = trapz(vNormalize,dr);
for nm=1:ss
phiVecNormalized(podModeNumber).c(currentCrossSection).m(currentAzimuthalMode).dat(nm) = phiVec(podModeNumber).c(currentCrossSection).m(currentAzimuthalMode).dat(nm)/normRes;
end % nm x 2
end % podMode
hold on;
%if 2 <= mm < azimuthalSetSize
%plot(real(phiVec(podModeNumber).c(currentCrossSection).m(currentAzimuthalMode).dat));
%end % if 

end % fc