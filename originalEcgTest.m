function originalEcgTest(peakSamplesArray)
load('C:\Users\amotz\amotz\for_nava\hep_project\hbd_datasets\hbd_mat\HBD_54.mat','EEG');
plot(EEG.data(67,:))
vline(peakSamplesArray)