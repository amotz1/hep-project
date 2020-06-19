function EEG = recover(data,setname,chanlocs)
pureEEG = fieldtrip2eeglab_moran(data); clear EEG; 
EEG = pureEEG;
EEG.setname = setname;
EEG.chanlocs = chanlocs;
EEG.nbchan = 72;
EEG.data = [pureEEG.data(1:64,:) ;EEG.data(65:73,:)];
