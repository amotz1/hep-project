function visualize_matrix(matrix, EEG)
EEG.trials = size(hepMat,3);
EEG.pnts = size(hepMat, 2);
EEG.xmax = size(hepMat,2)/EEG.srate;
EEG.chanlocs = EEG.chanlocs(1:64);
EEG.nbchan = size(hepMat,1);
EEG.data = hepMat;
browseTrialsEegLabData(EEG);