


fprintf('Calculating firing rate...  \n');
tic 


%  now determine discrete firing rate 
% par.N_last  = 2.05e7;
F.drate = zeros( size(par.MothN,1),par.N_last );

if par.diagnostic_fig
    f = figure(4);
        set(f,'name','Discrete firing rate ')
        f.Position = [100,100,500 900];
end

for j = 1:size(par.MothN,1)
    SpikeInd = round(  nonzeros(    Sp.(['M',num2str(par.MothN(j,1))])(:,par.MothN(j,2))      )*4e4  );
    SpikRel = SpikeInd(SpikeInd<par.N_last );
%     size(SpikeInd)
    if numel(SpikRel) ~=0
        clear dt
        dt(2:length(SpikRel)) = SpikRel(2:end) - SpikRel(1:end-1);
        dt(1) = SpikRel(1)+par.N_last -SpikRel(end);
        for j2 = 2:length(dt);
           F.drate(j,SpikRel(j2-1):SpikRel(j2)) = 4e4/dt(j2); 
        end
        F.drate(j,1:SpikRel(1)-1) =  4e4/dt(1);
        F.drate(j,SpikRel(end)+1:par.N_last ) =  4e4/dt(1);
    else
        F.drate(j,1:par.N_last ) = 0;
    end
    if par.diagnostic_fig
        subplot(8,8,j);
        plot( F.drate(j,1:1000:length(F.drate)) )
        drawnow
    end
    display(['firing rate',num2str(j)])
end

display('Discrete firing rate done')







%%  Smooth firing rate with Gaussian 
% contains Gaussian Gs .r(egular)   .c(alibrated)   .s(hifted)  
Pred = 1e4;
Pvec = 1:Pred:par.N_last ;
F.crate = zeros(size(par.MothN,1),length(Pvec));
Gsw = 40e3;                       % with of gaussian convolution 

F.local = zeros(size(par.MothN,1),26,60);
Gss = zeros(1,length(Pvec));

% LW = laswer window 
Lwidth = 1e5;
Loff = Lwidth + L.end(1,1)-L.st(1,1);
Lplotind = 1 : Pred : (Loff+3e5)   ;
Lbinon = (  logical((Lplotind >= Lwidth) .* (Lplotind <=Loff) )   );
Lindoff  = find(Lbinon,1,'last');
Lindon = find(Lbinon,1); 
Lcol = ['b';'c';'r';'g';'m'];
Lcol = linspecer(5);
 
for j = 1:size(par.MothN,1)
    Nj = length(Pvec);
    for k = 1:Nj 
        Im = floor(Nj/2);
        Gsr = exp(-(Pvec-Pvec(Im)).^2./Gsw^2);
        Gsc = Gsr /sum(Gsr);
        if k<Im
            Gss(1:k+Im) = Gsc(Nj-k-Im+1:Nj);
            Gss(k+Im+1:Nj) = Gsc(1:Nj-k-Im);
        elseif k ==Im
            Gss = Gsc;
        elseif k>Im
            Gss(1:Im-(Nj-k)) =  Gsc(Nj-k+Im+1:Nj); 
            Gss(Im-(Nj-k)+1:Nj) =  Gsc(1:Nj-k+Im); 
        end
        F.crate(j,k) = sum(F.drate(j,Pvec).*Gss);
        if mod(k,200) ==0
            stimn = par.MothN(j);
            if par.diagnostic_fig   % plot drawing the gaussian 
                f = figure(3);
                set(f,'name','Firing rate convolution with gaussian')
                f.Position = [600,600,400 400];
                for q = 1:L.pulses(stimn)
                     h(1:6) = fill([L.st(stimn,q);L.st(stimn,q);L.end(stimn,q);L.end(stimn,q)]/4e4,...
                         [0,1,1,0]*10,...
                         [0.8,0.8,0.8],'EdgeColor','none');
                        hold on
                end
                h(2) = plot(Pvec/4e4,F.drate(j,Pvec));
                h(3) = plot(Pvec/4e4,F.crate(j,:));
                h(4) = plot(Pvec/4e4,Gss/max(Gss)*18);
%                 axis([0,par.N_last /4e4,0,4]) ;      drawnow;        hold off
%                 axis([0,par.N_last /4e4,0,max(F.crate(j,:))]) ;      drawnow;        hold off
                xlabel('Time [s]');ylabel('firing rate [spikes/sec]')
                legend(h(1:4),'Laser ON','Discrete firing rate','Filtered firing rate','Gaussian filter')
                hold off
                drawnow
            end
        end        
    end
    

    stimn = par.MothN(j);
    
  
    for g = 1:L.pulses(stimn)
       stimrange = round(  L.st(stimn,g)-8e4 :Pred: L.end(stimn,g) + 32e4,-4);
       F.local(j,g,1:length( nonzeros(round((stimrange/Pred)) ) )  ) = F.crate(j,nonzeros(round((stimrange/Pred)) ) );
    end 
        
    if par.diagnostic_fig       
        f = figure(4);
            set(f,'name','Firing rate during laser')
            f.Position = [1200,100,500 900];
        clf(4)
        for g = 1:L.pulses(stimn)
           stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
           r = L.cat(stimn,g);
           c = sum( L.cat(stimn,1:g) == L.cat(stimn,g) );
           subplot(5,6,c + 6*(r-1))
               h(1) = fill([L.st(stimn,g);L.st(stimn,g);L.end(stimn,g);L.end(stimn,g)],...
                         [0,1,1,0]*10,...
                         [0.8,0.8,0.8],'EdgeColor','none');
               hold on
               h(2) = plot( stimrange( find(round(stimrange/Pred))  ), ...
                   F.crate(j,nonzeros(round((stimrange/Pred)) ) ) );
                    axis([stimrange(1),stimrange(end),0,8])
                    set(gca,'XTickLabel',{})
                    hold off
        end
        subplot(5,6,1);ylabel('Wing base')% ,'rot',0
            title(['# ',num2str(j)])
        subplot(5,6,7);ylabel('Near wing base')% ,'rot',0
        subplot(5,6,13);ylabel('Wing vein')% ,'rot',0
        subplot(5,6,19);ylabel('Wing tip')% ,'rot',0
        subplot(5,6,25);ylabel('Zero case')% ,'rot',0
        legend(h(1:2),'Laser ON','Firing rate')
        drawnow
    end
%     display(' got here' )
    Fcal = (  squeeze(F.local(j,:,1:60))  -...      % remove mean for Fcalibrated 
        repmat(  mean(squeeze(F.local(j,:,1:60)) ,2),1, size(F.local(j,1,:),3)))';
%     Fcal =   squeeze(F.local(j,:,1:60))' ;
    
%     display(' got here2 ' )
    NE.(['Nrate',num2str(j)]) = Fcal;

end










fprintf('Laser stimulus analyzed, took %d seconds \n',round(toc,0))














