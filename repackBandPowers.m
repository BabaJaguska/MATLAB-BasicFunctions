function [repackStrdERD, repackDvntERD]=repackBandPowers(data, templateStrd, templateDvnt)

% !!! IZBACILA repackStrd i repackDvnt iz OUT parametara !!!
% Repacks bundles of strd, deviand and multiple band data into two cell
% arrays, one containing all bands for standard trials, the other
% containing all bands for deviant trials
% IN:
% @param data: the data on one subject that is to be repacked. 
% The first element are standard epochs, the second one are deviant
% Within those one can find nBands rows, each of which is a 3D numeric
% matrix of nChans x nSamples x nSweeps corresponding to a single f band
% @class data: cell 2x2, and each of those are 3x3 cells
% @param templateStrd: template for standard epochs, where the "data"
% field should be modified
% @class templateStrd: struct
% @param templateDvnt: template for deviant epochs, where the "data"
% field should be modified
% @class templateDvnt: struct
% OUT
% @param repackStrd: Standard trials repacked into desired structure form
% for all bands
% @class repackStrd: cell 1 x nBands
% @param repackDvnt: Deviant trials repacked into desired structure form
% for all bands
% @class repackDvnt: cell 1 x nBands
% @param repackStrdERD: calculates ERD for standard trials and packs it
% into the corresponding template
% @clas repackStrdERD: cell 1 x nBands, containing 2D matrices, nChans x
% nSamples (SINGLE SUBJECT)
% @param repackDvntERD: calculates ERD for standard trials and packs it
% into thecorresponding template
% @clas repackDvntERD: cell 1 x nBands, containing 2D matrices nChans x
% nSamples (SINGLE SUBJECT)
% Calls @function ERDfromBandPower


nBands=size(data{1,1});
nBands=nBands(1);

strd=data{1};
dvnt=data{2};

% repackStrd=cell(1,3);
% repackDvnt=cell(1,3);

repackStrdERD=cell(1,3);
repackDvntERD=cell(1,3);

for i=1:nBands
%    repackDvnt{i}=templateDvnt;
%    repackStrd{i}=templateStrd;
%    repackStrd{i}.data=strd{i,1}; 
%    repackDvnt{i}.data=dvnt{i,1};
   
   % Calculate ERD
   % call ERDfromBandPower
   repackDvntERD{i}=templateDvnt;
   repackStrdERD{i}=templateStrd;
   repackStrdERD{i}.data=ERDfromBandPower(strd{i,1});
   repackDvntERD{i}.data=ERDfromBandPower(dvnt{i,1});
   repackStrdERD{i}.data=repmat(repackStrdERD{i}.data,1,1,2);
   repackDvntERD{i}.data=repmat(repackDvntERD{i}.data,1,1,2);
   repackStrdERD{i}.trials=2;
   repackDvntERD{i}.trials=2;
   
end


end