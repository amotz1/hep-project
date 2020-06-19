function EEG = convert2_73_EEG(EEG,ecg, chanlocs,events, setname)
tempEEG = EEG;
tempEEG.data = [EEG.data(1:68,:) ; ecg ; EEG.data(69:72,:)];
tempEEG.nbchan = 73;
tempEEG.events = events;
tempEEG.chanlocs = chanlocs; 
tempEEG.setname = setname;
EEG = tempEEG;