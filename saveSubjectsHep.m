function saveSubjectsHep(subjects)
%% loading the data and setting some constants
nCleanTrials = [];
subjectList = [];
badSensors = cell(1,length(subjects));
subjectIndex = 0;
for subject=subjects 
    subjectIndex = subjectIndex + 1; % need this counter for figures
    subjectNumberString = subjectNumber2String(subject);
    disp(subjectNumberString);
    EEG = loadData(subjectNumberString);
    baselineTimeWindow = [-200 -50];  % in ms'. for baseline correction
    rPeak = 200; %in ms' 
    baselineWindowInSamples= ceil((baselineTimeWindow + rPeak) * EEG.srate/1000) +1;
    % EEG = baseline_removal(EEG); some people recommand this to clean
    % filter artifacts
    EEG = downsample512(EEG);
    chanlocs = EEG.chanlocs;
    setname = EEG.setname;
    events = EEG.event;
    ecg_69 = EEG.data(69,:);
    ecg_68 = EEG.data(68,:);
    ecg_67 = EEG.data(67,:);
    EEG = convert2_EEGWithoutECG(EEG);
    EEG = pop_eegfiltnew(EEG,0.1,0,[],0,[]);
    EEG = pop_eegfiltnew(EEG,0,30,[],0,[]); 
    EEG = convert2_73_EEG(EEG,ecg_67,ecg_68,ecg_69, chanlocs,events,setname);
    EEG = ecgReference(EEG);
    EEG = eegReference(EEG);
    browseData(EEG);
    externalElectrodes = EEG.data(65:73,:); 
    EEG = convert2_64_electrodes(EEG);
    EEG = preformIca(EEG,chanlocs,events,setname);
    EEG = convert64_73(EEG,externalElectrodes,events,chanlocs,setname);
    [~,~,EEG] = split2Events(EEG);
    EEG = visualInspect(EEG);
    [hepMat] = hepTrialsHbd(EEG);
    %visualize_matrix(hepMat,EEG)
    [dataChanInterpulated, interpsensvec]  = scadsAK_3dchan(hepMat, EEG.chanlocs(1:64));
    disp(interpsensvec);
    [dataClean, NGoodtrials, badTrialsIndex] = scadsAK_3dtrials(dataChanInterpulated);
    nCleanTrials = [nCleanTrials NGoodtrials];
    badSensors{subjectIndex} = interpsensvec;
    subjectList = [subjectList subject];
    %visualize_matrix(dataClean, EEG);
    ROI_average = calculate_ROI_average(baselineWindowInSamples, dataClean);
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\saveSubjectsHep\\%dROI_average.mat',subject);
    plot(ROI_average);
    save(filename, 'ROI_average')
    group_hepERP(:,subject) = ROI_average;
    finalHep350_450 = mean(ROI_average(round(350*EEG.srate/1000):round(450*EEG.srate/1000))); % converting ms to samples (ms * s/1000ms * 512sample/s)
    finalHep450_550 = mean(ROI_average(round(450*EEG.srate/1000)+1:round(550*EEG.srate/1000)));
    finalHep550_650 = mean(ROI_average(round(550*EEG.srate/1000)+1:round(650*EEG.srate/1000)));
    %% saving the variable final hep
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\saveSubjectsHep\\%d finalHep350_450.mat',subject);
    save(filename, 'finalHep350_450')
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\saveSubjectsHep\\%d finalHep450_550.mat',subject);
    save(filename, 'finalHep450_550')
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\saveSubjectsHep\\%d finalHep550_650.mat',subject);
    save(filename, 'finalHep550_650')
end
groupMean_hepERP = nanmean(group_hepERP(:,:),2);
createFigures(subjectList, nCleanTrials, badSensors, groupMean_hepERP);
formatedString = createStringFormatAddition(subjectList);
filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\saveSubjectsHep\\groupMean_hepERP for subjects' + formatedString +".mat",subjectList);
save(filename, 'groupMean_hepERP')
