function [peakSamplesArray, stdPeakSamplesArray, averageDurations] = R_peaks_detection_and_properties(ecg,sampling_rate)
%   Remove lower frequencies
    samplingrate = sampling_rate;
    fresult=fft(ecg);
    fresult(1 : round(length(fresult)*5/samplingrate))=0;
    fresult(end - round(length(fresult)*5/samplingrate) : end)=0;
    corrected=real(ifft(fresult));
    figure
    plot(corrected)
    %windowing with han window but including the code with hamming window
    %as well for comparison reasons-i think han window is better
     n = 1:1:length(corrected);
     N= length(n);
     whm = 0.54 - 0.46 * cos(2*pi*n/N);
     whn = 0.5*(1-cos(2*pi*n/N));
     corrected = whm.*corrected;
    %   Filter - first pass
    WinSize = floor(samplingrate * 571 / 1000);
    if rem(WinSize,2)==0
        WinSize = WinSize+1;
    end
    filtered1=ecgdemowinmax(corrected, WinSize);
    %   Scale ecg
    peaks1=filtered1/(max(filtered1)/7);
    %   Filter by threshold filter
    for data = 1:1:length(peaks1)
        if peaks1(data) < 4
            peaks1(data) = 0;
        else
            peaks1(data)=1;
        end
    end
    positions=find(peaks1);
    distance=positions(2)-positions(1);
    for data=1:1:length(positions)-1
        if positions(data+1)-positions(data)<distance
            distance=positions(data+1)-positions(data);
        end
    end
    % Optimize filter window size
    QRdistance=floor(0.04*samplingrate);
    if rem(QRdistance,2)==0
        QRdistance=QRdistance+1;
    end
    WinSize=2*distance-QRdistance;
    % Filter - second pass
    filtered2=ecgdemowinmax(corrected, WinSize);
    peaks2=filtered2;
    positions = find(peaks2);
    for data=1:1:length(peaks2)
        if peaks2(data)<4
            peaks2(data)=0;
        else
            peaks2(data)=1;
        end
    end
    
    % calculating durations between r peaks and average of durations
    durations = zeros(1,length(positions)-1);
    for i = 1:length(positions)-1
        durations(i) = (positions(i+1) -positions(i))/sampling_rate;
    end
    
    peakSamplesArray = positions;
    averageDurations = mean(durations);
    stdPeakSamplesArray = std(positions);
    
    % visualizing intermidate results
    subplot(3, 2, 1); plot((ecg-min(ecg))/(max(ecg)-min(ecg)));
    title('\bf1. Original ECG'); ylim([-0.2 1.2]);
    %   ECG with removed low-frequency component
    subplot(3, 2, 2); plot((corrected-min(corrected))/(max(corrected)-min(corrected)));
    title('\bf2. FFT Filtered ECG'); ylim([-0.2 1.2]);
    %   Filtered ECG (1-st pass) - filter has default window size
    subplot(3, 2, 3); stem((filtered1-min(filtered1))/(max(filtered1)-min(filtered1)));
    title('\bf3. Filtered ECG - 1^{st} Pass'); ylim([0 1.4]);
    %   Detected peaks in filtered ECG
    subplot(3, 2, 4); stem(peaks1);
    title('\bf4. Detected Peaks'); ylim([0 1.4]);
    %   Filtered ECG (2-d pass) - now filter has optimized window size
    subplot(3, 2, 5); stem((filtered2-min(filtered2))/(max(filtered2)-min(filtered2)));
    title('\bf5. Filtered ECG - 2^d Pass'); ylim([0 1.4]);
    %   Detected peaks - final result
    subplot(3, 2, 6); stem(peaks2);
    title('\bf6. Detected Peaks - Finally'); ylim([0 1.4]);
    %   Plotting ECG in green
    plot((ecg-min(ecg))/(max(ecg)-min(ecg)), '-g'); title('\bf Comparative ECG R-Peak Detection Plot');
    %   Show peaks in the same picture
    hold on
    %   Stemming peaks in dashed black
    stem(peaks2'.*((ecg-min(ecg))/(max(ecg)-min(ecg)))', ':k');
    %   Hold off the figure
    hold off
    
    %visualizing results in matlab with vline
    figure
    hold on
    plot(ecg)
    vline(peakSamplesArray);
    hold off
 


