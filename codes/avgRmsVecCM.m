% v3 *has* timeblocing *and parallel*. however needs debugging bec the graph is not correct.
function avgRmsVecCM(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr,currentBloc)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
f=figure('Renderer', 'painters', 'Position', [10 10 1900 900],'Visible','on')
%[uuMTS]=initData2("rmsU");
[rmsVecAvg]=initData2("rmsVecM");

qq=open('/home/mi/citriniPodCode/GraphsAndData-spectralAnalysis/rmsVecCM.mat')
sprintf('%s','working..')

%qq.rmsVecCM(99).m(18).dat
for m=1:18
sprintf('%s%d%s' , 'Reading Data: m=',m,'.')
  avgVec=zeros(540,1);
  for c=1:18
    avgVec = avgVec + qq.rmsVecCM(c).m(m).dat ;
  end %c
  rmsVecAvg(m).dat = avgVec;
  end %m

end %fc
