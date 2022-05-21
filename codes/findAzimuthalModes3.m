% nb this function should only take azimuthal mode ...
function [qq]=findAzimuthalModes3(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr)
% [ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags]=constants();
  [ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
  [postAzimuthFft_noCsYet]=initData2("postAzimuthFft_noCsYet");
if aliasStr=="noAlias"
elseif aliasStr=="alias"
for timeBloc = 1:blocLength% time
    parfor t = 1:ntimesteps % time % parfor
        for  r = 1:540
            vec = zeros(1080,1);
            vec2 = zeros(1080,1);
            for zz=1:1080 % there are currently 1080 azimuthal modes.
            aa=qMinusQbar_noCsYet(t).circle(zz).dat(r,1); % this can perhaps be truncated to 540, then duplicated for the second half, too prevent aliasing.!
            vec(zz)= aa;
            end % for zz
            aa=fft(vec);
            bb = flip(aa);
            cc = zeros(1080,1);
            for i=1:540
              cc(i) =aa(i);
              cc(1080 - i + 1 ) = aa(i); % get all 1080
            end % i
            postAzimuthFft_noCsYet(t).circle(1,r).dat=cc;
        end % r...
    end % parfor t
clear qMinusQbar_noCsYet; % yes, clear this..
        saveStr=[saveDir 'qMinusQbar[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        load(saveStr,'qMinusQbar_noCsYet');
    ordStr="xcorrNow";
        parfor t=1:ntimesteps%
            vec = zeros(1,540); % collect radial points..
                for m=1:1080
                for r=1:540% size xcorr
                  aa = qMinusQbar_noCsYet(t).circle(m).dat(r,1);
                  vec(r) = aa;
                end % r
                  [bb, lags] = rcorr(vec,"normalized"); % bb is 1079 because of xcorr ! <- new annotat.
                xcorrDone(t).circle(m).dat=bb';
                end % m
        end % (little)t
  saveStr=[saveDir 'xcorrDone[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
   save(saveStr,'xcorrDone','-v7.3');
end % timeBloc % end timebloc here .. (updated order..)
qq = xcorrDone; % asign qq and exi
end % fc
