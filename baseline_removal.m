function EEG = baseline_removal(EEG)
for numChans = 1:size(EEG.data,1)
    EEG.data(numChans, :) = single(double(EEG.data(numChans, :))); 
    mean(double(EEG.data(numChans, :)));
end
