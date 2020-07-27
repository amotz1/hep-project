function EEG = convert64_73(EEG, externalElectrodes,events,chanlocs,setname)
tempEEG = EEG;
tempEEG.data = [EEG.data(1:64,:) ; externalElectrodes];
tempEEG.nbchan = 73;
tempEEG.events = events;
tempEEG.chanlocs = chanlocs; 
tempEEG.setname = setname;
EEG = tempEEG;