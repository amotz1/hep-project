function testEcg()
load('C:\Users\amotz\amotz\for_nava\hep_project\hbd_datasets\hbd_mat\HBD_56.mat','EEG');
ecg = EEG.data(69,:);
peak_samples = R_peaks_detection_and_properties(ecg,EEG.srate);
fEEG = pop_eegfiltnew(EEG,1,30,[],0,[]);
fEcg = fEEG.data(69,:);
reRef = 1
if reRef==0
    
    elecNo = size(fEEG.data,1);
    eReRef = 1:64; %both mastiodes
    
    fEEG.data(1:elecNo-1,:) = fEEG.data(1:elecNo-1,:) - mean(fEEG.data(eReRef,:),1); %subtracts the average activity of "eReRef" electrodes in each time point from all every time point in each electrode
    fRefEEG = fEEG;
    disp('success')
else
    elecNo = size(fEEG.data,1);
    eReRef = 65:66; %both mastiodes
    
    fEEG.data(1:elecNo-1,:) = fEEG.data(1:elecNo-1,:) - mean(fEEG.data(eReRef,:),1); %subtracts the average activity of "eReRef" electrodes in each time point from all every time point in each electrode
    fRefEEG = fEEG;
    disp('success1')
end
fRefEcg = fRefEEG.data(69,:);
fRefEcg_peak_samples = R_peaks_detection_and_properties(fRefEcg,EEG.srate);
disp(fRefEcg_peak_samples(1:20));
disp(peak_samples(1:20));