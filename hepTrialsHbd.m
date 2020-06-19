function [hepMat,rejectedTrials, trialREventIndices ] = hepTrialsHbd(EEG)

ecgData = EEG.data(69,:);
EEGData = EEG.data(1:64,:);
sRate = EEG.srate;

timeBeforeR = 200; %ms before R peak
timeAfterR = 600; %ms after R peak


samplesBeforeR = floor(timeBeforeR/ 1000 * sRate); % samples before R event
samplesAfterR = floor(timeAfterR / 1000 * sRate);  % samples after R event
totalSamplesNumber = samplesBeforeR + samplesAfterR ;


% rEvents = extractRevents(ecgData, sRate, 0);
% rEventIndices = find(rEvents);

% hepMatCondition = zeros(1,1000);
hepTrialCount =1;
% lost_IOA_Trials = zeros(1,trialInfo.trialNo);
% % for iT=1:trialInfo.trialNo %loop over IOA trials

% EEGDataCount = 1;
% for iT=find(trialInfo.goodTrials)
    
    
    % exclude samples before and after IOA trial
%     samplesBeforeDotsOnset = trialInfo.timeBeforeAfterTrial/1000*sRate;
%     ecgDataRange = ecgData(1+samplesBeforeDotsOnset:end,iT)';
    
    
%     try
trialREventIndices  = R_peaks_detection_and_properties(ecgData,sRate);
hepMat = zeros(size(EEGData,1),totalSamplesNumber, length(trialREventIndices));
%     catch
%         lost_IOA_Trials(iT) = 1;
%         continue;
%     end
   
disp(size(EEG.data));    
rejectedTrials = 0;
for iHEPT=1:length(trialREventIndices)-2 %loop over R events to create HEP trials
    hepEpochStart = trialREventIndices(iHEPT)- samplesBeforeR +1;
    hepEpochEnd = trialREventIndices(iHEPT) + samplesAfterR;
        
%         switch trialInfo.type(EEGDataCount)
%             case 2
%                 condition=1;
%             case 4
%                 condition=2;
%             case 8
%                 condition=3;
%         end

    if (hepEpochEnd+ceil(sRate/10))<trialREventIndices(iHEPT+1) % if the next R is within the 700 ms after
       if (trialREventIndices(iHEPT) > ceil(sRate/5) ) % 103 represents 200 ms after the begining of IOA trial
           hepMat(:,:,hepTrialCount) = EEGData(:,hepEpochStart:hepEpochEnd);
%                 hepMatCondition(hepTrialCount) =condition;
                
                hepTrialCount = hepTrialCount +1;
        
                
       end
    else
        rejectedTrials = rejectedTrials + 1;
    end      
end
%     EEGDataCount = EEGDataCount+1;
% end

hepMat(:,:,hepTrialCount:end) =[];
% hepMatCondition((hepTrialCount+1):end) = [];
% hepTrials.trialNo = hepTrialCount-1;
% hepTrials.lost_IOA_Trials =lost_IOA_Trials;
% trialInfo.HEP = hepTrials;

end