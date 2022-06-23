% v3 *has* timeblocing *and parallel*. however needs debugging bec the graph is not correct.
function avgRmsVecCM(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr,currentBloc)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
f=figure('Renderer', 'painters', 'Position', [10 10 1900 900],'Visible','on')
[uuMTS]=initData2("rmsU");

qq=open('/home/mi/citriniPodCode/GraphsAndData-spectralAnalysis')


end %fc 