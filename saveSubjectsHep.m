function saveSubjectsHep()
%% loading the data and setting some constants
subjects = [55, 43, 56]; % vector of subjects numbers 
nCleanTrials = [];
nBadChannels = [];
subjectList = [];
stringFormatAddition = [];
for i=subjects   
    subjectNumberString = subjectNumber2String(i);
    EEG = loadData(subjectNumberString);
    baselineTimeWindow = [-200 -50];  % in ms'. for baseline correction
    rPeak = 200; %in ms' 
    baselineWindowInSamples= ceil((baselineTimeWindow + rPeak) * EEG.srate/1000) +1;
    chanlocs = EEG.chanlocs;
    setname = EEG.setname;
    events = EEG.event;
    % EEG = baseline_removal(EEG); some people recommand this to clean
    % filter artifacts
    % EEG = downsample512(EEG);
    ecg_69 = EEG.data(69,:);
    ecg_68 = EEG.data(68,:);
    ecg_67 = EEG.data(67,:);
    EEG = convert2_EEGWithoutECG(EEG);
    EEG = pop_eegfiltnew(EEG,0.5,0,[],0,[]);
    EEG = pop_eegfiltnew(EEG,0,30,[],0,[]);
    EEG = convert2_73_EEG(EEG,ecg_67,ecg_68,ecg_69, chanlocs,events,setname);
    EEG = ecgReference(EEG);
    EEG = eegReference(EEG);
    EEG = visualInspect(EEG);
    ecg = EEG.data(69,:);
    EEG = convert2_64_electrodes(EEG);
    EEG = preformIca(EEG,chanlocs);
    [hepMat] = hepTrialsHbd2(EEG,ecg);
    %visualize_matrix(hepMat,EEG)
    [dataChanInterpulated, interpsensvec]  = scadsAK_3dchan_reporting_failed_interpolation(hepMat, EEG.chanlocs(1:64),i);
    [dataClean, NGoodtrials, badTrialsIndex] = scadsAK_3dtrials(dataChanInterpulated);
    nCleanTrials = [nCleanTrials NGoodtrials];
    if size(nBadChannels,2) < length(interpsensvec)
        nBadChannels = [nBadChannels  zeros(size(nBadChannels,1),length(interpsensvec)- size(nBadChannels,2))'];
    else
        interpsensvec = [interpsensvec zeros(size(nBadChannels,2)-length(interpsensvec),1)'];
    end
    nBadChannels = [nBadChannels ; interpsensvec];
    subjectList = [subjectList subjectNumber];
    %visualize_matrix(dataClean, EEG);
    ROI_average = calculate_ROI_average(baselineWindowInSamples, dataClean);
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\testingpipeline\\%dROI_average.mat',subjectNumber);
    save(filename, 'ROI_average')
    group_hepERP(:,i) = ROI_average;
    finalHep = mean(ROI_average(500:600));
    %% saving the variable final hep
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\testingpipeline\\%dfinalHep.mat',subjectNumber);
    save(filename, 'finalHep')
end
groupMean_hepERP = nanmean(group_hepERP(:,:),2);
createFigures(subjectList, nCleanTrials, nBadChannels,groupMean_hepERP);
formatedString = createStringFormatAddition(subjectList);
filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\saveSubjectsHep\\groupMean_hepERP for subjects' + formatedString +".mat",subjectList);
save(filename, 'groupMean_hepERP')
