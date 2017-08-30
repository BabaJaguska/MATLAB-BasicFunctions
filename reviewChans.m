function [channelsOutAlpha channelsOutBeta channelsOutGamma]=reviewChans(channelsInAlpha,channelsInBeta,channelsInGamma)
% IN:
% @param channelsInAlpha, channelsInBeta, channelsInGamma:
% set od all (probably 128) channels for review (in alpha, beta and gamma bands respectively)
% expected BANDPOWER, not raw signals
% @class channelsInAlpha, channelsInBeta, channelsInGamma:
% numeric matrix 3D (nChans x nSamples x nSweeps)
% OUT:
% @param channelsOutAlpha, channelsOutBeta, channelsOutGamma:
% reduced number of sweeps possibly, after removal of noisy trials
% and keeping only the selectedChans
% @class channelsOutAlpha, channelsOutBeta, channelsOutGamma:
% DATA, custom handle class,defined in DATA.m
% DATA.data contains data in a cell
% DATA.channels contains the indices of selected channels
% since it containes a varying numbers of sweeps

assert(nargin==3,'Function reviewChans takes exactly 3 arguments.')
assert(length(size(channelsInAlpha))==3,...
    'The input data should be a 3D matrix: nChans x nSamples x nSweeps ')
assert(length(size(channelsInBeta))==3,...
    'The input data should be a 3D matrix: nChans x nSamples x nSweeps ')
assert(length(size(channelsInGamma))==3,...
    'The input data should be a 3D matrix: nChans x nSamples x nSweeps ')

% Sorta kinda equivalents to the 10-20 system
% Need to change the field "chanlocs" in the EEGlab template
% subset the existing with these indices:
selectedChans=[11,14,21,24,34,36,40,53,59,62,70,83,86,91,104,109,116,124];
% you can plot their positions by using EEGlab's pop_chanedit
% and then plotting

nChansNEW=length(selectedChans);

channelsOutAlpha=DATA(cell(1,nChansNEW),[]);
channelsOutBeta=DATA(cell(1,nChansNEW),[]);
channelsOutGamma=DATA(cell(1,nChansNEW),[]);

s=size(channelsInAlpha);
s1=size(channelsInBeta);
s2=size(channelsInGamma);
% nSamples=s(2);
nSweeps=s(3);


assert(s(3)==s1(3)&&s(3)==s2(3),...
            'ERROR: Different number of sweeps in the three bands!')


for i=1:3 %length(selectedChans)
   
   ch=selectedChans(i);
   signalAlpha=squeeze(channelsInAlpha(ch,:,:));
   signalBeta=squeeze(channelsInBeta(ch,:,:));
   signalGamma=squeeze(channelsInGamma(ch,:,:));
   % Plot your signals
   figure(i)
   subplot(3,1,1)
     plot(signalAlpha)
     title(strcat('ALPHA band - channel #',num2str(ch)))
   subplot(3,1,2)
     plot(signalBeta)
     title(strcat('BETA band - channel #',num2str(ch)))
   subplot(3,1,3)
     plot(signalGamma)
     title(strcat('GAMMA band - channel #',num2str(ch)))
    
   % Create DIALOG 
   d=dialog('Name','Review Channel','WindowStyle','normal');
   txt=uicontrol('Parent',d,...
            'Position',[120 350 300 20],...
            'Style','text',...
            'String',strcat('Choose action for current channel:',num2str(ch)));
   popup=uicontrol('Parent',d,...
            'Position',[170,300,200,30],...
            'Style','popup',...
            'String',{' ';'Keep';'Threshold';'Replace Channel'},...
            'callback',{@popupCallback,signalAlpha,signalBeta,signalGamma,...
                        nSweeps,channelsOutAlpha, channelsOutBeta, channelsOutGamma,...
                        i,ch,channelsInAlpha,channelsInBeta,channelsInGamma});
   button=uicontrol('Parent',d,...
            'Style','pushbutton',...
            'Position',[170 200 200 30],...
            'String','OK',...
            'Callback','close all');
      
   uiwait(d)
end

    

function popupCallback(popup,event,signalAlpha,signalBeta,signalGamma,...
                            nSweeps,channelsOutAlpha, channelsOutBeta, channelsOutGamma,...
                            ind,ch,channelsInAlpha,channelsInBeta,channelsInGamma)
        idx=get(popup,'value');
        channelsAdd=ch;
        newSignalAlpha=signalAlpha;
        newSignalBeta=signalBeta;
        newSignalGamma=signalGamma;
        switch(idx)
            case 1
                disp('I''m sure you wanted to select something else.')
            case 2
                %keep
                disp('Keeping the channel as it is.')                
            case 3
                % threshold
                threshold=inputdlg('Specify the desired threshold value');
                threshold=str2double(threshold{1});
                badSweepsIdx=[];
                for j=1:nSweeps
                    if sum(find(abs(signalAlpha(:,j))>=threshold))>0
                        badSweepsIdx=[badSweepsIdx j];
                    end
                    if sum(find(abs(signalBeta(:,j))>=threshold))>0
                        badSweepsIdx=[badSweepsIdx j];
                    end
                    if sum(find(abs(signalGamma(:,j))>=threshold))>0
                        badSweepsIdx=[badSweepsIdx j];
                    end
                end
                newSignalAlpha(:,badSweepsIdx)=[];
                newSignalBeta(:,badSweepsIdx)=[];
                newSignalGamma(:,badSweepsIdx)=[];
                
                %Plot the 
                figure(ind)
                subplot(3,1,1)
                    plot(signalAlpha)
                    title(strcat('ALPHA band - channel #',num2str(ch),' THRESHOLDED'))
                subplot(3,1,2)
                    plot(signalBeta)
                    title(strcat('BETA band - channel #',num2str(ch),' THRESHOLDED'))
                subplot(3,1,3)
                    plot(signalGamma)
                    title(strcat('GAMMA band - channel #',num2str(ch),' THRESHOLDED'))
                disp('Keeping the channel but removing epochs that contain values over the threshold')
                disp('Close the figure and press OK to continue reviewing...')
            case 4
                % replace channel
                
                disp('Please wait till we plot your options');
                nearby={[16,17],9,22,[27,19],28,[30,35],[39,41],[54,52],...
                        [66,60],[72,67,77],[75,69],[75,89],[79,92],[84,85],...
                        [105,110],[115,103],117,[4,123]};
                chansToPlot=nearby{ind};
                figure()
                for k=1:length(chansToPlot)
                    subplot(length(chansToPlot),1,k)
                    plot(squeeze(channelsInAlpha(chansToPlot(k),:,:)))
                    title(strcat('Channel #',num2str(chansToPlot(k))))
                end
                channelsAdd=inputdlg('Which channel to take as substitute?');
                channelsAdd=str2num(channelsAdd{1});
                newSignalAlpha=squeeze(channelsInAlpha(channelsAdd,:,:));
                newSignalBeta=squeeze(channelsInBeta(channelsAdd,:,:));
                newSignalGamma=squeeze(channelsInGamma(channelsAdd,:,:));
                disp(['Replacing the channel by channel #',num2str(channelsAdd)])
                disp('Close the figure and press OK to continue reviewing...')
                
        end
        
        channelsOutAlpha.data{ind}=newSignalAlpha;
        channelsOutBeta.data{ind}=newSignalBeta;
        channelsOutGamma.data{ind}=newSignalGamma;
        channelsOutAlpha.channels=[channelsOutAlpha.channels channelsAdd];
        channelsOutBeta.channels=[channelsOutBeta.channels channelsAdd];
        channelsOutGamma.channels=[channelsOutGamma.channels channelsAdd];
        
    end

end

