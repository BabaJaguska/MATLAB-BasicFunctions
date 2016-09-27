function [data, noFiles, filenames]=ReadOneOrMoreSignals()
%%%% Reads one or more *.csv files
%%%% Made primarily for EMG data recorded by bonestim/maxens hybrid stimulators
%%%% but can work for other data too
%%%% Returns data in a cell array (even if only 1 file)

% READ FILES
filenames=uigetfile('*.csv','Multiselect','ON');
if ~ischar(filenames)
    noFiles=length(filenames); 
    data=cell(1,noFiles);
    for i=1:noFiles
        data{i}=csvread(filenames{i});
    end
else 
    noFiles=1;
    data{1}=csvread(filenames);
end
  
end

