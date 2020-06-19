function [beatsPerMinute] = computeHeartRate()
load('C:\Users\amotz\amotz\for_nava\hep_project\hbd_datasets\hbd_mat\HBD_54.mat','EEG');
peakSamples = R_peaks_detection_and_properties(EEG.data(69,:), EEG.srate);
beatsPerMinute = 1/(mean(diff(peakSamples))) * EEG.srate * 60;