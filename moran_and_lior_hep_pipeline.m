function moran_and_lior_hep_pipeline()
%% loading the data and setting some constants
load('C:\Users\amotz\amotz\for_nava\hep_project\hbd_datasets\hbd_mat\HBD_43.mat','EEG');
baselineTimeWindow = [-200 -50];  % in ms'. for baseline correction
rPeak = 200; %in ms'
baselineWindowInSamples= ceil((baselineTimeWindow + rPeak)* EEG.srate/1000) +1;
chanlocs = EEG.chanlocs;
setname = EEG.setname;
browseEegLabData(EEG);
ecg = EEG.data(69,:);
copy_EEG = EEG;
% for i = 1:64
%     eegLabData.data(i,:) = eegLabData.data(i,:) - mean(eegLabData.data(i,:));
% end

%% ----- downsampling
% downsrate = 512;
% %--- resample to downsrate Hz
% if EEG.srate ~= downsrate
%     fEEG = pop_resample( EEG, downsrate );
%     fEEG.chanlocs = EEG.chanlocs;
%     EEG = fEEG;
% end


%% ------- filter first time for ica with highpass filter of 1 hertz 
% bandpass filter between 1 to 30 HZ (not 60 Hz)
fEEG = pop_eegfiltnew(EEG,1,30,[],0,[]);
browseEegLabData(fEEG);
% EEG= fEEG; 
%% ------ rereferenceing (linked mastoids or avarage)
reRef = 0;
if reRef==1
    
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
%% visual artifact rejection
visualInspectedData = browseEegLabData(fRefEEG);
visualInspectedData.trial = {[visualInspectedData.trial{:}]};
viFRefEEG = fieldtrip2eeglab_moran(visualInspectedData);
viFRefEEG.chanlocs = chanlocs;
viFRefEEG.setname = setname;
browseEegLabData(viFRefEEG);

%% spliting the dataset to prepare for Ica (eeg alone, eeg+ecg or all the data) 
electrodes_for_ica = 64;
if electrodes_for_ica == 72
    [data, ~] = eeglab2fieldtrip_lior(viFRefEEG,'preprocessing');
elseif electrodes_for_ica == 64
    pureEEG = viFRefEEG;
    pureEEG.data = viFRefEEG.data(1:64,:);
    pureEEG.nbchan = size(pureEEG.data,1);
    pureEEG.chanlocs = chanlocs(1:64); 
    [data, ~] = eeglab2fieldtrip_lior(pureEEG,'preprocessing');
else
    EEG = viFRefEEG;
    EEG.data = [viFRefEEG.data(1:64,:) ;  ecg];
    EEG.nbchan = size(EEG.data,1);
    EEG.chanlocs = [chanlocs(1:64) chanlocs(69)]; 
    [data, ~] = eeglab2fieldtrip_lior(EEG,'preprocessing');
end
%% ------- run ica to get the unmixing matrix 
cfg = [];
cfg.channel = {'all'};
% cfg.channel = {'all', '-EXG1',  '-EXG2', '-EXG3', '-EXG4','-EXG5','-EXG6','-EXG7','-EXG8'};
cfg.method = 'sobi';
comp = ft_componentanalysis(cfg, data);
%% browse ica
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.viewmode = 'component';
ft_databrowser(cfg, comp);
%% filter for erp the copy of the dataset (0.1Hertz or 0.3Hertz or 0.5Hertz)
highpass = 0.3;
if highpass == 0.1
    fCopyEEG = pop_eegfiltnew(copy_EEG,0.1,30,[],0,[]);
    browseEegLabData(fCopyEEG);
elseif highpass == 0.3
    fCopyEEG = pop_eegfiltnew(copy_EEG,0.3,30,[],0,[]);
    browseEegLabData(fCopyEEG);
else
    fCopyEEG = pop_eegfiltnew(copy_EEG,0.5,30,[],0,[]);
    browseEegLabData(fCopyEEG);
end
%% saving fCopyEEG varible
cutoff = 0.5;
filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\hbd_56\\moran_and_lior_pipeline\\%0.1fhPassFilter\\fCopyEEG.mat',cutoff);
save(filename, 'fCopyEEG')

%% ------ rereferenceing the copy dataset (avarage or linked mastoids)
reRef = 0;
if reRef==1
    
    elecNo = size(fCopyEEG.data,1);
    eReRef = 1:64; %both mastiodes
    
    fCopyEEG.data(1:elecNo-1,:) = fCopyEEG.data(1:elecNo-1,:) - mean(fCopyEEG.data(eReRef,:),1); %subtracts the average activity of "eReRef" electrodes in each time point from all every time point in each electrode
    fRefCopyEEG = fCopyEEG;
    disp('success');
else
    elecNo = size(fEEG.data,1);
    eReRef = 65:66; %both mastiodes
    
    fCopyEEG.data(1:elecNo-1,:) = fCopyEEG.data(1:elecNo-1,:) - mean(fCopyEEG.data(eReRef,:),1); %subtracts the average activity of "eReRef" electrodes in each time point from all every time point in each electrode
    fRefCopyEEG = fCopyEEG;
    disp('success1')
end

%% visual artifact rejection in the copy dataset
visualInspectedData = browseEegLabData(fRefCopyEEG);
visualInspectedData.trial = {[visualInspectedData.trial{:}]};
viFRefCopyEEG = fieldtrip2eeglab_moran(visualInspectedData);
viFRefCopyEEG.chanlocs = chanlocs;
viFRefCopyEEG.setname = setname;
browseEegLabData(viFRefCopyEEG);
%% spliting the dataset in preparation to ICA (eeg alone, eeg+ecg,all the data)
if electrodes_for_ica == 72
    [data, ~] = eeglab2fieldtrip_lior(viFRefCopyEEG,'preprocessing');
elseif electrodes_for_ica == 64
    pureEEG = viFRefCopyEEG;
    pureEEG.data = viFRefCopyEEG.data(1:64,:);
    pureEEG.nbchan = size(pureEEG.data,1);
    pureEEG.chanlocs = chanlocs(1:64); 
    [data, ~] = eeglab2fieldtrip_lior(pureEEG,'preprocessing');
else
    EEG = viFRefCopyEEG;
    EEG.data = [viFRefCopyEEG.data(1:64,:) ;  viFRefCopyEEG.data(69,:)];
    EEG.nbchan = size(EEG.data,1);
    EEG.chanlocs = [chanlocs(1:64) chanlocs(69)]; 
    [data, ~] = eeglab2fieldtrip_lior(EEG,'preprocessing');
end
%% rejecting components from the data
% compi = input('which component would you like to reject?\n');
cfg = [];
cfg.component = [001 004];
[data] = ft_rejectcomponent(cfg, comp,data);
%% recovering all the other electrodes to create the whole dataset again if needed
if electrodes_for_ica == 72
    IcafRefEEG = fieldtrip2eeglab_moran(data); clear EEG;
    IcafRefEEG.chanlocs = chanlocs;
    IcafRefEEG.setname = setname;
    IcafRefEEG.data(69,:) = ecg;
elseif electrodes_for_ica == 64
    pureEEG = fieldtrip2eeglab_moran(data); clear EEG;
    IcafRefEEG = pureEEG;
    IcafRefEEG.setname = setname;
    IcafRefEEG.chanlocs = chanlocs;
    IcafRefEEG.nbchan = size(viFRefEEG.data,1);
    IcafRefEEG.data = [pureEEG.data(1:64,:) ; viFRefEEG.data(65:72,:)];
else
    EEG = fieldtrip2eeglab_moran(data); 
    IcafRefEEG = EEG;
    IcafRefEEG.setname = setname;
    IcafRefEEG.chanlocs = chanlocs;
    IcafRefEEG.nbchan = size(viFRefEEG.data,1);
    IcafRefEEG.data = [EEG.data(1:64,:) ; viFRefEEG.data(65:72,:)];
browseEegLabData(IcafRefEEG)
end
%%
cutoff = 0.5;
filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\hbd_56\\moran_and_lior_pipeline\\%0.1fhPassFilter\\IcafRefEEG.mat',cutoff);
save(filename, 'IcafRefEEG')
%% -------- call the function hepTrialsHbd2 to creat the hep matrix (hepMat)
[hepMat,rejectedTrials] = hepTrialsHbd2(IcafRefEEG,ecg);
disp(rejectedTrials);
disp(size(hepMat));
%% transfering the data to eeglab data structure for visualization
dataAfterEpoching = IcafRefEEG;
dataAfterEpoching.trials = size(hepMat,3);
dataAfterEpoching.pnts = size(hepMat, 2);
dataAfterEpoching.xmax = size(hepMat,2)/IcafRefEEG.srate;
dataAfterEpoching.chanlocs = chanlocs(1:64);
dataAfterEpoching.nbchan = size(hepMat,1);
dataAfterEpoching.data = hepMat;
browseTrialsEegLabData(dataAfterEpoching);
%%
cutoff = 0.5;
filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\hbd_56\\moran_and_lior_pipeline\\%0.1fhPassFilter\\dataAfterEpoching.mat',cutoff);
save(filename, 'dataAfterEpoching')
%% --------Interpulate and reject trials using the functions I gave you: scadsAK_3dchan and scadsAK_3dtrials (on yor diskonkey)
[dataChanInterpulated, interpsensvec]  = scadsAK_3dchan(hepMat, IcafRefEEG.chanlocs(1:64));
[dataClean, NGoodtrials, badTrialsIndex ] = scadsAK_3dtrials(dataChanInterpulated);
disp(size(dataClean))
disp('size of the clean data');
disp(size(dataClean));
disp('bad channels');
disp(interpsensvec);
%% transfering the clean data to eeg data structure for visualization
cleanData = IcafRefEEG;
cleanData.trials = size(dataClean,3);
cleanData.pnts = size(dataClean, 2);
cleanData.xmax = size(dataClean,2)/IcafRefEEG.srate;
cleanData.chanlocs = chanlocs(1:64);
cleanData.nbchan = size(dataClean,1);
cleanData.data = dataClean;
%% visualizing the cleaned dataset 
browseTrialsEegLabData(cleanData)
%% --------apply baseline correction

hepERP = mean(dataClean(:,:,:),3);
%hepERP_blc = hepERP - mean(hepERP(baselineWindowInSamples(1):baselineWindowInSamples(2)));
hepERP_blc1 = hepERP - mean(hepERP(:,baselineWindowInSamples(1):baselineWindowInSamples(2)),2);
%% calculate ROI_Average
hepERP_blc1_ROI = hepERP_blc1([1:7 9:11 33:42 44:47], :);
ROI_average = mean(hepERP_blc1_ROI, 1);

%% visualizing the hep-thanks to my friend gal on the idea to use subplot :)
for i = 1:64
    subplot(8,8,i)
    plot(hepERP_blc1(i,:))
end

%% visualize ROI_average
figure 
plot(ROI_average)
%%
cutoff = 0.5;
filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\hbd_56\\moran_and_lior_pipeline\\%0.1fhPassFilter\\ROI_average.mat',cutoff);
save(filename, 'ROI_average')
%% making the final hep point
finalHep = mean(ROI_average(500:600));
%%
cutoff = 0.5;
filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\hbd_56\\moran_and_lior_pipeline\\%0.1fhPassFilter\\finalHep.mat',cutoff);
save(filename, 'finalHep')