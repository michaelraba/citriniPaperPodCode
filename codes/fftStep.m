 function [qq]=fftStep(stepStr,preStr)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();

 dr = 9.276438000000004e-04 + zeros(ss,1);
rMat=0:dr:.50001; % [0, ...,0.5] with 540 elements %  needs checked

  %[xcorrDoneAnticipate_cs]=initData2("xcorrDoneAnticipate_cs");
%ntimestepsX = 2*ntimesteps - 1; % number of offsets with xcorr.
% dont use.ntimestepsX = 2*ntimesteps - 1; % number of offsets with xcorr.
  if stepStr=="readDataAndFindVeloFluctuation"
    [qMinusQbar_noCsYet]=initData2("qMinusQbar_noCsYet"); % initialize avg struct
    [qMinusQbar]=initData2("qMinusQbar"); % initialize avg struct
    [myPreFft_noCsYet]=initData2("myPreFft_noCsYet");
    [avgPreFft_noCsYet]=initData2("avgPreFft_noCsYet");
    [xcorrDone]=initData2("azimuthDoneXcorrDone");
    [qMinusQbar_noCsYet]=initData2("qMinusQbar_noCsYet");
    [xdirNew]=initData2("xdirNew");
    [xdirPostFft]=initData2("xdirPostFft");
    [avgTimeEnd]=initData2("avgTimeEnd");
    
    for c = 1:ncs  % crosssection
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Step A) load a chonk into memory and read circles in.
    for timeBloc=1:blocLength
    parfor t = 1:ntimesteps % time % <-- nb, this is the parfor loop.
    myPreFft_noCsNoTimeYet=readCircles2(timeBloc*t,c);
    myPreFft_noCsYet(t).circle=myPreFft_noCsNoTimeYet;
    sprintf('%s','pause')
    end % parfor
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % after each block is done, find the average
    for t = 1:ntimesteps % time % <-- nb, this is the parfor loop.
      if timeBloc==blocLength && t==ntimesteps
        lastStr="last";
      else
        lastStr="notLast";
      end
    [avgPreFft_noCsYet]=findQbar(t,c,myPreFft_noCsYet,avgPreFft_noCsYet,lastStr); % find temporal average.
    end % end little t
    end % timeBloc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for timeBloc=1:blocLength
    for t = 1:ntimesteps % time % parfor
% load in time bloc again
        myPreFft_noCsNoTimeYet=readCircles2(timeBloc*t,c);
        myPreFft_noCsYet(t).circle=myPreFft_noCsNoTimeYet;
        % for each loaded timebloc, find qMinusQbar..
        [ qMinusQbar_noCsYet(t) ]=FindqMinusQbar(t,c,myPreFft_noCsYet(t),avgPreFft_noCsYet,qMinusQbar_noCsYet(t),"efficient");
    end % parfor t
    % this should be saved to disk immediately, for each timeBloc...
        sprintf('%s','saving qMinusQbar...')
        saveStr=[saveDir 'qMinusQbar[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        save(saveStr,'qMinusQbar_noCsYet','-v7.3');
        sprintf('%s%s','Saved velocity fluctuations into file ',saveStr);

    qq = qMinusQbar_noCsYet(t);
    findAzimuthalModes4(t,c, qMinusQbar_noCsYet,xcorrDone,"alias",timeBloc)
    end % timeblock
    sprintf('%s','start azimuthal')
    %qq = xcorrDone;
    end %c % yes, cross-section loop should indeed end here..
        %elseif stepStr=="azimuth"
        end % if
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x-dir fft
% read in one of the saved xcorrDone
for timeBloc=1:blocLength
for currentCrossSec=1:ncs
saveStr=[saveDir 'postAzimuth[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
qq=open(saveStr);
sprintf('%s','start azimuthal')
% now re-organize:
for t=1:ntimesteps %parfor
for r=1:540 % 
    azimCounter=1;
for m=1:azimuthalSetSize
  %aa=qq.xcorrDone(t).circle(m).dat(r,1); % that creates a hard copy, inefficient.
  aa=qq.postAzimuthFft_noCsYet(t).circle(r).dat(m,1); % that creates a hard copy, inefficient.
%qq.postAzimuthFft_noCsYet(4).circle(540).dat(1080)  
  xdirNew(t).RadialCircle(r).azimuth(azimCounter).dat(currentCrossSec,1) = aa;
  azimCounter=azimCounter+1;
end % m
end % r
end % t (little)
sprintf('%s%d%s%d%s','done filling in a crosssec for timeBloc=', timeBloc, ' and t=',t,'.')
end % c

% begin fft x-dir
for t=1:ntimesteps % parfor
for r=1:540 % this should be 540..................
for m=1:azimuthalSetSize
  aa = xdirNew(t).RadialCircle(r).azimuth(m).dat;
  %ab = fft(aa(end/2:end));
  ab = fft(aa);
  xdirPostFft(t).RadialCircle(r).azimuth(m).dat = ab;

end % m
end % r
end % t (little)
        sprintf('%s','saving xdirPostFft...')
        saveStr=[saveDir 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        save(saveStr,'xdirPostFft','-v7.3');
        sprintf('%s%s','Saved xdirpostfft into file ',saveStr);
% radial averaging
%%
aMat = zeros(540,1);

% form corrmat before averginng in r 
corrMat = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
for c=1:ncs
for m=1:azimuthalSetSize
for r=1:540
for tBlock=1:blocLength
% open blocfile
saveStr=[saveDir 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
qq=open(saveStr);
xdirPostFft=qq.xdirPostFft;

for t=1:ntimesteps
for tPr=1:ntimesteps
aa = xdirPostFft(t*blocLength).RadialCircle(r).azimuth(m).dat(c,1);
bb = xdirPostFft(tPr*blocLength).RadialCircle(r).azimuth(m).dat(c,1);
cc=aa*ctranspose(bb);
corrMatPreAvg(m).c(c).r(r).dat(t,tPr)=cc;
end %tPr
end %t
end %bloclength


end %r
end %m
end %c

% r-average.
for t=1:ntimesteps
for tPr=1:ntimesteps
for c=1:ncs
for m=1:azimuthalSetSize
for r=1:540
   %aa = xdirPostFft(t).RadialCircle(r).azimuth(m).dat(c,1);
   aa=corrMatPreAvg(m).c(c).r(r).dat(t,tPr);
   aMat(r) = rMat(r)*aa; % aa should be tt correlation
end % r
Rint = trapz(aMat);
%Rmat_avg(t).cs(c).circle(m)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
corrMatRavg(m).c(c).dat(t,tPr)= Rint; % smits17.eq.below.eq.2.4 % needs checking.

end % m
end % c
end % tPr (little)
end % t (little)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%end % timeBloc

% set back in radial direction and time avergae for all timesteps!

        saveStr=[saveDir '/corrMatRavg[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '.mat'];
        save(saveStr,'corrMatRavg','-v7.3');

% average in r smits2016

%   smits2016(t).cs(c).circle(m).dat(r,1) = aa; % R(t,t';k;m,r)
% just call trapz. then operate on t -> eig wrt .

qq = xdirPostFft;


snapshotPod(); %  
% qq(4).RadialCircle(540).azimuth  
 end % f
