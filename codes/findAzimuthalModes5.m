% for snapshot pod -> uses direct multiplicaiton in order to form correlation matrix.
%
function findAzimuthalModes5(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr)
% [ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags]=constants();
  [ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
  [postAzimuthFft_noCsYet]=initData2("postAzimuthFft_noCsYet");
if aliasStr=="noAlias"
elseif aliasStr=="alias"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% begin azimuthal ->
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
timeBloc=1; % set htat temporarily.
    for t = 1:ntimesteps % time % parfor
        for  r = 1:540
            vec = zeros(1080,1);
            vec2 = zeros(1080,1);
            for zz=1:1080 % there are currently 1080 azimuthal modes.
            aa=qMinusQbar_noCsYet(t).circle(zz).dat(r,1); % this can perhaps be truncated to 540, then duplicated for the second half, too prevent aliasing.!
            vec(zz)= aa;
            end % for zz
            aa=fft(vec);
            %bb = flip(aa);
            cc = zeros(1080,1);
            for i=1:540
              cc(i) =aa(i);
              cc(1080 - i + 1 ) = aa(i); % get all 1080
            end % i
            postAzimuthFft_noCsYet(t).circle(1,r).dat=cc; % there are indeed 540 circles.
        end % r...
    end % parfor t

clear qMinusQbar_noCsYet; % yes, clear this..
%$%$    for timeBloc = 1:blocLength% time % disable; already declared above in fftAzimuth
        saveStr=[saveDir 'qMinusQbar[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        load(saveStr,'qMinusQbar_noCsYet');
    ordStr="xcorrNow";
        sprintf('%s%f','$$ For xcorr, c is',currentCrossSec)
        %for r=1:540%
        for r=1:1080% %
            vec = zeros(1,ntimesteps); % collect radial points..
                for m=1:540
                %for m=1:azimuthalSetSize %%%%%

                for t=1:ntimesteps% %
                    % the meaning of r and m was switched.
                    % remember that circle is the 540 radial points. the
                    % .dat is indeed the azimuthal points
                  aa = postAzimuthFft_noCsYet(t).circle(m).dat(r,1);
                  vec(t) = aa;
                end % t
                   if abs(vec) ==0
                       [bb, lags] = xcorr(vec);
                   else
                  [bb, lags] = xcorr(vec,"normalized"); % bb is 1079 because of xcorr ! <- new annotat.
                   end % if 0 condition
                  for t=1:ntimesteps% % % add this sfor t-corr
                xcorrDone(t).circle(m).dat(r,1)=bb((ntimesteps)/2 + t); % only save half
                %xcorrDone(t).circle(m).dat(r,1)=bb(end/2 + t - 1); % only save half

                end % t
                end % m
        end % r
 saveStr=[saveDir 'xcorrDone[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
   save(saveStr,'xcorrDone','-v7.3');
qq = xcorrDone; % asign qq and exit
end % fc
