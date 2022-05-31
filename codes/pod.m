% Snapshot POD driver function
function pod(uXfft)
%function pod()
%figure(1);
hold on;
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir,csSet,timeSet]=constants();
        saveStr=[saveDir 'corrMatYa[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
        qq=open(saveStr);
        Rmat_avg=qq.corrMatYa; % Rmat(time).cs(cs).circle(=azimuthalSetSize1:18)
        clear qq;
        sprintf('%s','dbg')
for cc=1:ncs % streamwise mode % cannot exceed 1... 
for mm=1:azimuthalSetSize % azimuthal mode
 c = Rmat_avg(mm).x(1).dat;
sprintf('%s','take eigenvals');
[eigVec_tmp,eigVal_tmp]=eig(c);
[d,ind] = sort(diag(eigVal_tmp),'descend');
eigVal=eigVal_tmp(ind,ind);
eigVec= eigVec_tmp(:,ind);
tTrapz=zeros(ntimesteps,1);
%phiVec=zeros(ss,1);
for rr=1:ss
for tt=1:ntimesteps
    % fftTransformedFluctuation(18).cs(3).rad  
    % uXfft(18).cs(3).rad  
    aa=uXfft(mm).cs(cc).rad(rr).dat(tt); % t, r , m , c
    % must distinguish between alpha^{n} (t)
  bb=ctranspose(eigVec(tt)); % 
  ab = aa*bb;   
  tTrapz(tt) = ab;
  end % tt
ad= trapz(tTrapz);
phiVec(cc).m(mm).dat(rr) = ad/(eigVal(tt,tt)*ntimesteps); % smits.eq.2.5
end %rr
hold on;
if 2 <= mm < azimuthalSetSize
%plot(real(phiVec));
end % if 
end % circle mm
end % ncs

end % fc
