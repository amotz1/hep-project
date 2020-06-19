function ROI_average = calculate_ROI_average(baselineWindowInSamples, cleanData)
%% --------average across epochs and baseline removal
hepERP = nanmean(cleanData(:,:,:),3);
%hepERP_blc = hepERP - mean(hepERP(baselineWindowInSamples(1):baselineWindowInSamples(2)));
hepERP_blc1 = hepERP - nanmean(hepERP(:,baselineWindowInSamples(1):baselineWindowInSamples(2)),2);
%% calculate ROI and ROI average
hepERP_blc1_ROI = hepERP_blc1([9:11 44:47], :);
ROI_average = nanmean(hepERP_blc1_ROI, 1);