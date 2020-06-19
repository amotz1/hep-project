function [ inmat3d, NGoodtrials, badindex ] = scadsAK_3dtrials(inmat3d);
% caluclate three metrics of data quality at the trial level
    
    absvalvec = squeeze(median(median(abs(inmat3d),2'),'omitnan')); % Median absolute voltage value for each trial

    stdvalvec = squeeze(median(std(inmat3d,[],2),'omitnan')); % SD of voltage values
    
    maxtransvalvec = squeeze(median(max(diff(inmat3d, 2),[], 2),'omitnan')); % Max diff (??) of voltage values
    
    % calculate compound quality index and discard outlier trials
    qualindex = absvalvec./max(absvalvec)+ stdvalvec./max(stdvalvec)+ maxtransvalvec./max(maxtransvalvec); 
    
     cutoff = quantile(qualindex, .95);
     
     actualdistribution = qualindex(qualindex < cutoff); 
     
     plot(qualindex)
    
    badindex = find(qualindex > 1.2.* median(actualdistribution,'omitnan'));
    
    inmat3d(:, :, badindex) = []; 
    
    % calculate remaining number of trials
    qualindex(qualindex > 1.2.* median(qualindex,'omitnan')) = [];
    
%     NGoodtrials = length(qualindex); This is the line in the original
%     script but it's incompatible with the number of good trial indices so
%     see correction in the next line - ME&LK

NGoodtrials = size(inmat3d,3);  



