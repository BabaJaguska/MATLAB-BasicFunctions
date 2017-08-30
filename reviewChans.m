%Review selected channels
function channelsOut=reviewChans(channelsIn)
% IN:
% @param channelsIn: A set od all (probably 128) channels for review:
% expected BANDPOWER, not raw signals
% @class channelsIn: numeric matrix 3D (nChans x nSamples x nSweeps)
% OUT:
% @param channelsOut: reduced number of sweeps possibly, after
% removal of noisy trials and keeping only the selectedChans
% @class channelsOut: DATA, custom handle class,defined in DATA.m
% DATA.data contains data in a cell
% DATA.channels contains the indices of selected channels
% since it containes a varying numbers of sweeps

assert(nargin==1,'Function reviewChans takes exactly 1 argument.')
assert(length(size(channelsIn))==3,...
    'The input data should be a 3D matrix: nChans x nSamples x nSweeps ')


% Sorta kinda equivalents to the 10-20 system
% Need to change the field "chanlocs" in the EEGlab template
% subset the existing with these indices:
selectedChans=[11,14,21,24,34,36,40,53,59,62,70,83,86,91,104,109,116,124];
% you can plot their positions by using EEGlab's pop_chanedit
% and then plotting

nChansNEW=length(selectedChans);

channelsOut=DATA(cell(1,nChansNEW),[]);

s=size(channelsIn);
% nSamples=s(2);
nSweeps=s(3);

for i=1:length(selectedChans)
   figure(i)
   ch=selectedChans(i);
   signal=squeeze(channelsIn(ch,:,:));
   plot(signal)
   d=dialog('Name','Review Channel','WindowStyle','normal');
   txt=uicontrol('Parent',d,...
            'Position',[120 350 300 20],...
            'Style','text',...
            'String',strcat('Choose action for current channel:',num2str(ch)));
   popup=uicontrol('Parent',d,...
            'Position',[170,300,200,30],...
            'Style','popup',...
            'String',{' ';'Keep';'Threshold';'Replace Channel'},...
            'callback',{@popupCallback,signal,nSweeps,channelsOut,i,ch,channelsIn});
   button=uicontrol('Parent',d,...
            'Style','pushbutton',...
            'Position',[170 200 200 30],...
            'String','OK',...
            'Callback','close all');
      
   uiwait(d)
end

    

    function popupCallback(popup,event,signal,nSweeps,signalDATA,ind,ch,channelsIn)
        idx=get(popup,'value');
        channelsAdd=ch;
        newSignal=signal;
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
                    if sum(find(abs(signal(:,j))>=threshold))>0
                        badSweepsIdx=[badSweepsIdx j];
                    end
                end
                newSignal(:,badSweepsIdx)=[];
                figure()
                plot(newSignal)
                title(strcat('Here''s your channel #',num2str(ch),...
                    ' when thresholded @',num2str(threshold)))
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
                    plot(squeeze(channelsIn(chansToPlot(k),:,:)))
                    title(strcat('Channel #',num2str(chansToPlot(k))))
                end
                channelsAdd=inputdlg('Which channel to take as substitute?');
                channelsAdd=str2num(channelsAdd{1});
                newSignal=squeeze(channelsIn(channelsAdd,:,:));
                disp(['Replacing the channel by channel #',num2str(channelsAdd)])
                disp('Close the figure and press OK to continue reviewing...')
                
        end
        
        signalDATA.data{ind}=newSignal;
        signalDATA.channels=[signalDATA.channels channelsAdd];
        
    end

end

