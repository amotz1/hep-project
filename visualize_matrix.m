function visualize_matrix(matrix, EEG)
EEG.trials = size(matrix,3);
EEG.pnts = size(matrix, 2);
EEG.xmax = size(matrix,2)/EEG.srate;
EEG.chanlocs = EEG.chanlocs(1:64);
EEG.nbchan = size(matrix,1);
EEG.data = matrix;
browseTrialsEegLabData(EEG);