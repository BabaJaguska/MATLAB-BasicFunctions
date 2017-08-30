function channelsOutERD = ERDfromBandPower(channelsIn)

% ERDfromBandPower calculates Event Related Synchronization (ERS)/ Event
% Related Desynchronization (ERD) of EEG (SSEP) bandpower data in a specific
% frequency band 
% ERD/ERS represents the relationship of bandpower before and
% after the onset of the simulus
% IN:
% @param channelsIn: matrix containing bandpower in a certain frequency
% band for a number of channels (nChans - expected 128) and
% a number of trials (nSweeps - expected 100)
% @class channelsIn: numeric matrix 3D (nChans x nSamples x nSweeps)
% OUT:
% @param channelsOutERD: matrix containing ERD/ERS in the given frequency band
% @class channelsOutERD: numeric matrix 2D (nChans x nSamples)

s=size(channelsIn);
nChans=s(1);
nSamples=s(2);
nSweeps=s(3);

channelsOutERD=zeros(nChans,nSamples);

for i=1:nChans
    P=squeeze((1/(nSamples-1))*sum(squeeze(channelsIn(i,:,:)),2));
    
    P=P+10; %add random constant to avoid negative values for the time being
    
    % the following assumes the time starts at -100 in increments of 2ms
    R=(1/50)*sum(P(1:50));
    channelsOutERD(i,:)=100*(P-R)./R;        
end

end