function EEG = convert2_EEGWithoutECG(EEG)
chanlocs = [EEG.chanlocs(1:68) EEG.chanlocs(70:73)];
setname = EEG.setname;
tempEEG = EEG;
tempEEG.data = [EEG.data(1:68,:) ; EEG.data(70:73,:)];
tempEEG.nbchan = 72;
tempEEG.chanlocs = chanlocs; 
tempEEG.setname = setname;
EEG = tempEEG;