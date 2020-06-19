function EEG = eegReference(EEG)
reRef = 1;

if reRef==0
    
    elecNo = size(EEG.data,1);
    eReRef = 1:64; %both mastiodes
    
    EEG.data(1:elecNo-1,:) = EEG.data(1:elecNo-1,:) - mean(EEG.data(eReRef,:),1); %subtracts the average activity of "eReRef" electrodes in each time point from all every time point in each electrode
    disp('success')
else
    elecNo = size(EEG.data,1);
    eReRef = 65:66; %both mastiodes
    
    EEG.data(1:elecNo-1,:) = EEG.data(1:elecNo-1,:) - mean(EEG.data(eReRef,:),1); %subtracts the average activity of "eReRef" electrodes in each time point from all every time point in each electrode
    disp('success1')
end