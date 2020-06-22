function EEG = convert2_73_EEG(EEG,ecg_67,ecg_68,ecg_69, chanlocs,events, setname)
tempEEG = EEG;
tempEEG.data = [EEG.data(1:66,:) ; ecg_67 ; ecg_68; ecg_69 ; EEG.data(67:70,:)];
tempEEG.nbchan = 73;
tempEEG.events = events;
tempEEG.chanlocs = chanlocs; 
tempEEG.setname = setname;
EEG = tempEEG;