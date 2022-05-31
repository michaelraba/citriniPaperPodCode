function plotSkmr(plotObject,isGraph)
[ntimesteps rMin ,rMax, ss ,ncs ,plotOn ,azimuthalSet, azimuthalSetSize ,printStatus, lags,csSet,timeSet]=constants();
if isGraph=="graph"
  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900])
  cMaxx=2;
  A=linspace(0,1,ss)
  xlabel('radius $\frac{r}{R}$','interpreter','latex')
  ylabel("$S_{ii}(k,m;r,r')$",'interpreter','latex')  
  hold on;
  for c=1:cMaxx
      subplot(cMaxx,1,1);

      %for t=1:ntimesteps
      for m=4:azimuthalSetSize
      
      labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
      pp=plot(A,real(plotObject(c).m(m).dat/ntimesteps),"DisplayName",labelStr);
      tiSt=['Streamwise mode: ' num2str(c)  ];
      title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
      if c==1
      legend();
      end
      hold on;
      end % m
      cou = cou + 1;
  end %c
elseif isGraph=="graphPause"
  hold on;
    for m=2:38
    for c=1:ncs
    plot(real(plotObject(m).crosssection(c).dat(end/2:end) )/ntimesteps)
    hold on;
    pause(1);
    end
    end
    %sprintf('%s','pause');
      pause(1)
else
end % if
  titleStrr=['Snapshot POD modes $\Phi_{ii}(k,m;r)$ for (tTot,xTot)=(' num2str(ntimesteps) ',' num2str(ncs) ') Uniformly Sampled']
  sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex')
  xlabel('1-r','interpreter','latex')

if isGraph=="avg" % plot the avg of the cross sections
  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900])
  cMaxx=2;
  A=linspace(0,1,ss)
  %A=linspace(0,1,1079)
  xlabel('radius $\frac{r}{R}$','interpreter','latex')
  ylabel("$S_{ii}(k,m;r,r')$",'interpreter','latex')
  hold on;
  cou = 1


for podModeNumber=1:3
    for m=1:azimuthalSetSize
      % initialize with each azimuthal mode.
        avgPlotting(m).dat = zeros(1,540);
    for c=1:ncs
      avgPlotting(m).dat = plotObject(podModeNumber).c(c).m(m).dat + avgPlotting(m).dat;
    end % c
    end % m
          %subplot(cMaxx,1,cou);
          subplot(3,1,podModeNumber);
          for m=5:azimuthalSetSize
          labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
          xlabel('1-r','interpreter','latex')

          pp=plot(A,flip(real(avgPlotting(m).dat/(ntimesteps*ncs))),"DisplayName",labelStr);
          tiSt=['$\Phi^{(' num2str(podModeNumber) ')}_{ii}(k,m;r)$'];
          title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
          if podModeNumber==1
          legend();
          end
          hold on;
          end % m
          cou = cou + 1;
    %  end %c

end % podModeNumber
  titleStrr=['Snapshot POD modes for (tTot,xTot)=(' num2str(ntimesteps) ',' num2str(ncs) ') Uniformly Sampled']
  sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex')

end % f
