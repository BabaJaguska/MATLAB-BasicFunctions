function [signals, metadata, noFiles, filenames]=ReadOneOrMoreEDF()
%%%% Reads one or more *.edf files
%%%% Common extension for EEG data
%%%% DEPENDENCY: edfead.m

% READ FILES
filenames=uigetfile('*.edf','Select the EEG files to read','MultiSelect','ON');
if ~ischar(filenames)
    noFiles=length(filenames); 
    signals=cell(noFiles);
    medatada=cell(noFiles);
    for i=1:noFiles
        [temp1 temp2]=edfread(filenames{i});
        signals{i}=temp2;
        metadata{i}=temp1;
    end
else 
    noFiles=1;
    [temp1 temp2]=edfread(filenames);
    signals=temp2;
    metadata=temp1;
end
  
end

