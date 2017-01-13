% New laser stim analysis
% TMOHREN 25 Oct 

clc;clear all;close all
set(0,'DefaultlinelineWidth',2)

% location data: 'C:\Users\Daniellab\Desktop\Revised Stim'
figure_on = 1;
n_moths = 2;
N_last = 2.05e7;  % last input to read 
%% 
tic;
run('Load_data')
toc
%%
run('laser_stim')
%%
run('firing_rate')
%% 
run('find_location')
%% 
% run('plot_laserresponse')
%%
figure()

for j = 1:size(MothN,1)
    NE.(['N',num2str(j)]).Sp = nonzeros(Sp.(['M',num2str(MothN(j,1))])(:,MothN(j,2)));
end
location_names = {'base','2','3','4','control'};
%     
for j = 1:size(MothN,1)
    if (j-1)/10 ==  floor((j-1)/10)
        figure('Position', [50,50,1200 950] )
        subplot(10,5,1)
        title(['Using mean, unsorted  ',num2str(floor((j-1)/10)+1)])
        hold on 
    end
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+1    )
        fill( [Lindon,Lindon,Lindoff,Lindoff] ,...
                [0,1,1,0]-0.5,...
                [0.8,0.8,0.8],'EdgeColor','none')    
        hold on 
        plot(M1(:,j)/norm(M1(:,j)),'LineWidth',[2.5])
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+2  )
        hold on 
        for k = 1:5
            bar( find( L.cat( MothN( SC.Is(j)   ,1),:) ==k)    ,...
            M1_proj(j ,  find( L.cat( MothN(SC.Is(j),1),:) ==k) ), 'FaceColor',Lcol(k,:),'EdgeColor','none')
                hold on 
        end

    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+3  )
        plot( (1:2.05e4)/2e4, F.drate(j,1:1000:length(F.drate)) )
   
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+4  )        
        text(0.2,0.9,['n of spikes wigglephase = ',num2str( sum(NE.(['N',num2str(j)]).Sp*4e4>N_last))]);
        text(0.2,0.7,['n of spikes Laserphase = ',num2str( sum(NE.(['N',num2str(j)]).Sp*4e4<N_last))]);
        text(0.2,0.3,['M',num2str(MothN(j,1)),' N',num2str(MothN(j,2))]);
        if SC.V(j) >= 5
            text(0.2,0.1,['Location: ', location_names{SC.gr(j)}]);
        end
end




























%% Make Unsorted output table/figure


for j = 1:size(MothN,1)
    NE.(['N',num2str(j)]).U = U_modes(j,:);
    NE.(['N',num2str(j)]).V = V_Vec(j,:);
    NE.(['N',num2str(j)]).Sp = nonzeros(Sp.(['M',num2str(MothN(j,1))])(:,MothN(j,2)));
end
location_names = {'base','2','3','4','control'};
%     
for j = 1:size(MothN,1)
    if (j-1)/10 ==  floor((j-1)/10)
        figure('Position', [50,50,1200 950] )
        subplot(10,5,1)
        title(['Unsorted neuron sheet using SVD  ',num2str(floor((j-1)/10)+1)])
        hold on 
    end
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+1    )
        fill( [Lindon,Lindon,Lindoff,Lindoff] ,...
                [0,1,1,0]-0.5,...
                [0.8,0.8,0.8],'EdgeColor','none')    
        hold on 
        temp = NE.(['Nrate',num2str(j)])(:,:)./norm(NE.(['Nrate',num2str(j)])(:,:));
        plot(temp(:,1:5)*3,'--b','LineWidth',[1])
        plot(NE.(['N',num2str(j)]).U,'LineWidth',[2.5])
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+2  )
        hold on 
        for k = 1:5
            bar( find( L.cat( MothN( SC.Is(j)   ,1),:) ==k)    ,...
            V_Vec(j ,  find( L.cat( MothN(SC.Is(j),1),:) ==k) ), 'FaceColor',Lcol(k,:),'EdgeColor','none')
                hold on 
        end

    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+3  )
        plot( (1:2.05e4)/2e4, F.drate(j,1:1000:length(F.drate)) )
   
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+4  )        
        text(0.2,0.9,['n of spikes wigglephase = ',num2str( sum(NE.(['N',num2str(j)]).Sp*4e4>N_last))]);
        text(0.2,0.7,['n of spikes Laserphase = ',num2str( sum(NE.(['N',num2str(j)]).Sp*4e4<N_last))]);
        text(0.2,0.3,['M',num2str(MothN(j,1)),' N',num2str(MothN(j,2))]);
        if SC.V(j) >= 5
            text(0.2,0.1,['Location: ', location_names{SC.gr(j)}]);
        end
end

























%% Make output table/figure, sorted figure

% NE = {};
for j = 1:size(MothN,1)
    NE.(['N',num2str(j)]).U = U_modes(j,:);
    NE.(['N',num2str(j)]).V = V_Vec(j,:);
    NE.(['N',num2str(j)]).Sp = nonzeros(Sp.(['M',num2str(MothN(j,1))])(:,MothN(j,2)));
end
ind_good = SC.Is(SC.Vs>5);
ind_bad = SC.Is(SC.Vs<=5);
location_names = {'base','2','3','4','control'};

for j = 1:length(ind_good)
    if (j-1)/10 ==  floor((j-1)/10)
        figure('Position', [50,50,1200 950] )
        subplot(10,5,1)
        title(['Good Neurons sheet ',num2str(floor((j-1)/10)+1)])
        hold on 
    end      
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+1    )
        fill( [Lindon,Lindon,Lindoff,Lindoff] ,...
                [0,1,1,0]-0.5,...
                [0.8,0.8,0.8],'EdgeColor','none')    
        hold on 
        plot(NE.(['N',num2str(ind_good(j))]).U)
        temp = NE.(['Nrate',num2str(ind_good(j))])(:,:)./norm(NE.(['Nrate',num2str(ind_good(j))])(:,:));
        plot(temp(:,1:5)*3,'--b','LineWidth',[1])
%     figure(20+1 + floor((j-1)/10) )
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+2  )
        hold on 
        for k = 1:5
            bar( find( L.cat( MothN( SC.Is(ind_good(j))   ,1),:) ==k)    ,...
            V_Vec(ind_good(j) ,  find( L.cat( MothN(SC.Is(ind_good(j)),1),:) ==k) ),'FaceColor',Lcol(k,:),'EdgeColor','none')
                hold on 
        end
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+3  )
        plot( (1:2.05e4)/2e4, F.drate(ind_good(j),1:1000:length(F.drate)) )
       
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+4  )
        text(0.2,0.6,['n of spikes = ',num2str( length(NE.(['N',num2str(ind_good(j))]).Sp)) ]);
        text(0.2,0.4,['M',num2str(MothN(ind_good(j),1)),' N',num2str(MothN(ind_good(j),2))]);
        if SC.V(ind_good(j)) >= 5
            text(0.2,0.1,['Location: ', location_names{SC.gr(ind_good(j))}]);
        end
end

for j = 1:length(ind_bad)
    if (j-1)/10 ==  floor((j-1)/10)
        figure('Position', [50,50,1200 950] )
        subplot(10,5,1)
        title(['Bad Neurons sheet ',num2str(floor((j-1)/10)+1)])
        hold on 
    end
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+1    )
        fill( [Lindon,Lindon,Lindoff,Lindoff] ,...
                [0,1,1,0]-0.5,...
                [0.8,0.8,0.8],'EdgeColor','none')    
        hold on 
        plot(NE.(['N',num2str(ind_bad(j))]).U)
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+2  )
        hold on 
        for k = 1:5
            bar( find( L.cat( MothN( SC.Is(ind_bad(j))   ,1),:) ==k)    ,...
            V_Vec(ind_bad(j) ,  find( L.cat( MothN(SC.Is(ind_bad(j)),1),:) ==k) ), 'FaceColor',Lcol(k,:),'EdgeColor','none')
                hold on 
        end
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+3  )
        plot( ((1:2.05e4))/2e4, F.drate(ind_bad(j),1:1000:length(F.drate)) )
        
        
    subplot(10,5,( j-1- (floor((j-1)/10))*10)*5+4  )
        text(0.2,0.6,['n of spikes = ',num2str( length(NE.(['N',num2str(ind_bad(j))]).Sp)) ]);
        text(0.2,0.4,['M',num2str(MothN(ind_bad(j),1)),' N',num2str(MothN(ind_bad(j),2))]);
        if SC.V(ind_bad(j)) >= 5
            text(0.2,0.1,['Location: ', location_names{SC.gr(ind_bad(j))}]);
        end
end




%% Make explanatory paper fig 

j = 7

% col = 
if 0
    figure('Position', [50,50,1300 950])
        subplot(511)
        for q = 1:L.pulses(stimn)
             h(1:6) = fill([L.st(stimn,q);L.st(stimn,q);L.end(stimn,q);L.end(stimn,q)]/4e4,...
                 [0,1,1,0]*15,...
                 [0.8,0.8,0.8],'EdgeColor','none');
                hold on
        end
        plot( Pvec/4e4 , F.crate(j,:),'k','LineWidth',[1])
          for g = 1:L.pulses(stimn)
              stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
               r = L.cat(stimn,g);
               c = sum( L.cat(stimn,1:g) == L.cat(stimn,g) );
    %                h(1) = fill([L.st(stimn,g);L.st(stimn,g);L.end(stimn,g);L.end(stimn,g)],...
    %                          [0,1,1,0]*10,...
    %                          [0.8,0.8,0.8],'EdgeColor','none');
    %                hold on
                   tempt = stimrange( find(round(stimrange/Pred))  )/4e4;
                   tempf = F.crate(j,nonzeros(round((stimrange/Pred)) ) );
                   plot( tempt(1:35), ...
                        tempf(1:35),'Color',Lcol(L.cat(2,g),:),'LineWidth',[3]);
            end


        axis([0,500,0,10])

    subplot(537)
    hold on
          for g = 1:L.pulses(stimn)
              stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
               r = L.cat(stimn,g);
               c = sum( L.cat(stimn,1:g) == L.cat(stimn,g) );
                   h(1) = fill(  [40*(g-1)+5;40*(g-1)+5;40*(g-1)+25;40*(g-1)+25],...
                             [0,1,1,0]*10,...
                             [0.8,0.8,0.8],'EdgeColor','none');
                   hold on
                   tempt = stimrange( find(round(stimrange/Pred))  )/4e4;
                   tempf = F.crate(j,nonzeros(round((stimrange/Pred)) ) );
                   plot( (1:35)+40*(g-1), ...
                        tempf(1:35),'Color',Lcol(L.cat(2,g),:),'LineWidth',[3]);
          end
            axis([0,40+40*25,0,8])

    %     
    subplot(5,6,[9,21])
                   h(1) = fill([5;5;25;25],...
                             [0,1,1,0]*250,...
                             [0.8,0.8,0.8],'EdgeColor','none');
                         hold on
            for g = 1:L.pulses(stimn)
              stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
                   tempf = F.crate(j,nonzeros(round((stimrange/Pred)) ) );
                   plot(tempf(1:35) + 8*25-8*g,'Color',Lcol(L.cat(2,g),:),'LineWidth',3)
                   hold on
            end
            axis([-80,80,0,200])
    subplot(5,6,16)
        hold on 
                for g = 1:L.pulses(stimn)
                  stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
                       tempf = F.crate(j,nonzeros(round((stimrange/Pred)) ) );
                       plot( ((tempf-mean(tempf))/norm(tempf))*2,'Color',Lcol(L.cat(2,g),:),'LineWidth',2)
                       hold on
        %                plot( tempt(1:35), ...
        %                     tempf(1:35),'r');
                end
        plot(U_modes(j,:),'k','LineWidth',4)
        axis([0,50,-.4,.4])
    subplot(5,6,22)
        plot(S_vec(j,:)/sum(S_vec(j,:)),'o')
        axis([1,10,0,.5])
    subplot(5,6,[17,18])
        for k = 1:5
            bar( find( L.cat( MothN( j   ,1),:) ==k)    ,...
            V_Vec(j ,  find( L.cat( MothN(j,1),:) ==k) ),'EdgeColor','none', 'FaceColor',Lcol(k,:))
                hold on 
        end
    subplot(515)
          for g = 1:L.pulses(stimn)
              stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
               r = L.cat(stimn,g);
               c = sum( L.cat(stimn,1:g) == L.cat(stimn,g) );
                   h(1) = fill([L.st(stimn,g);L.st(stimn,g);L.end(stimn,g);L.end(stimn,g)]/4e4,...
                             [0,1,1,0]*V_Vec(j,g),...
                             Lcol(L.cat(2,g),:),'EdgeColor','none');
                   hold on
            end
end



%% Make explanatory paper fig now using mean 

j = 7

% col = 
if 1
    figure('Position', [50,50,1300 950])
        subplot(311)
        for q = 1:L.pulses(stimn)
             h(1:6) = fill([L.st(stimn,q);L.st(stimn,q);L.end(stimn,q);L.end(stimn,q)]/4e4,...
                 [0,1,1,0]*200,...
                 [0.8,0.8,0.8],'EdgeColor','none');
                hold on
        end
        plot( Pvec/4e4 , F.crate(j,:),'k','LineWidth',[1])
          for g = 1:L.pulses(stimn)
              stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
               r = L.cat(stimn,g);
               c = sum( L.cat(stimn,1:g) == L.cat(stimn,g) );
    %                h(1) = fill([L.st(stimn,g);L.st(stimn,g);L.end(stimn,g);L.end(stimn,g)],...
    %                          [0,1,1,0]*10,...
    %                          [0.8,0.8,0.8],'EdgeColor','none');
    %                hold on
                   tempt = stimrange( find(round(stimrange/Pred))  )/4e4;
                   tempf = F.crate(j,nonzeros(round((stimrange/Pred)) ) );
                   plot( tempt(1:35), ...
                        tempf(1:35),'Color',Lcol(L.cat(2,g),:),'LineWidth',[3]);
          end

        xlabel('Time [s]')
        ylabel('Firing rate [f/s]')
        axis([0,500,0,120])

    subplot(335)
                   h(1) = fill( ([5;5;25;25]-5)/4,...
                             [0,1,1,0]*40-20,...
                             [0.8,0.8,0.8],'EdgeColor','none');
                         hold on
        hold on 
                  stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
        t_temp = (-10:1:49)/4;
        plot(t_temp,M1(:,j),'k','LineWidth',4)
        axis([-10/4,50/4,min(M1(:,j)*1.1),max(M1(:,j)*1.1)])
        xlabel('Time [s]')
        ylabel('Frate [f/s]' )

    subplot(313)
          for g = 1:L.pulses(stimn)
              stimrange = round(  L.st(stimn,g)-5e4 :Pred: L.end(stimn,g) + 3e5,-4);
               r = L.cat(stimn,g);
               c = sum( L.cat(stimn,1:g) == L.cat(stimn,g) );
                   h(1) = fill([L.st(stimn,g);L.st(stimn,g);L.end(stimn,g);L.end(stimn,g)]/4e4,...
                             [0,1,1,0]*M1_proj(j,g)/norm(M1_proj),...
                             Lcol(L.cat(2,g),:),'EdgeColor','none');
                   hold on
          end
            xlabel('Time [s]' )
%             ylabel(' $(X \cdot \bar{X})/|(X \cdot \bar{X})|$','Interpreter','LaTex' )
            ylabel(' $\frac{X \cdot \bar{X}}{|X \cdot \bar{X}|}$','Interpreter','LaTex' )
      plot([0,500],[0,0],'k')
      
end