function finalHep = moran_and_lior_hep_pipeline1()
%% loading the data and setting some constants
load('C:\Users\amotz\amotz\for_nava\hep_project\hbd_datasets_fileio\HBD_55.mat','EEG');
baselineTimeWindow = [-200 -50];  % in ms'. for baseline correction
rPeak = 200; %in ms' 
baselineWindowInSamples= ceil((baselineTimeWindow + rPeak) * EEG.srate/1000) +1;
chanlocs = EEG.chanlocs;
setname = EEG.setname;
events = EEG.event;
% EEG = baseline_removal(EEG);
browseEegLabData(EEG);
%%
% EEG = downsample512(EEG);
%%
% EEG = pop_eegfiltnew(EEG,0.1,30,[],0,[]);
EEG = pop_eegfiltnew(EEG,0.1,0,[],0,[]);
EEG = pop_eegfiltnew(EEG,0,30,[],0,[]);
browseEegLabData(EEG);
%%
EEG = ecgReference(EEG);
EEG = eegReference(EEG);
ecg = EEG.data(69,:);
browseEegLabData(EEG);
%%
EEG = visualInspect(EEG);
%%
EEG = convert2_64_electrodes(EEG);
%%
data = preformIca(EEG);
EEG = fieldtrip2eeglab_moran(data);
%% -------- call the function hepTrials_resting_state to creat the hep matrix (hepMat)
%[hepMat,rejectedTrials] = hepTrialsHbd(viFRefEEG);
[hepMat,rejectedTrials] = hepTrialsHbd2(EEG);
disp('number of rejected trials');
disp(rejectedTrials);
disp('size of hepMat');
disp(size(hepMat));
%% transfering the matrix into a EEGLAB object in preparation for visualization
visualize_matrix(hepMat,EEG)

%% --------Interpulate and reject trials using the functions I gave you: scadsAK_3dchan and scadsAK_3dtrials (on yor diskonkey)
%[dataChanInterpulated, interpsensvec]  = scadsAK_3dchan(hepMat, viFRefEEG.chanlocs(1:64));
[dataChanInterpulated, interpsensvec]  = scadsAK_3dchan(hepMat, EEG.chanlocs(1:64));
[dataClean, NGoodtrials, badTrialsIndex ] = scadsAK_3dtrials(dataChanInterpulated);
disp('size of the clean data');
disp(size(dataClean));
disp('bad channels');
disp(interpsensvec);

%% visualizing dataClean
visualize_matrix(dataClean, EEG);
%%
ROI_average = calculate_ROI_average(baselineWindowInSamples, dataClean);
%% saving the variable ROI_average
filename = 'C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\hbd_43\\ROI_average.mat';
save(filename, 'ROI_average')
%% visualize ROI_average
figure 
plot(ROI_average)
%% making the final hep point
finalHep = mean(ROI_average(500:600));
%% saving the variable final hep
filename = 'C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\hbd_43\\moran_and_lior_pipeline1\\finalHep.mat';
save(filename, 'finalHep')