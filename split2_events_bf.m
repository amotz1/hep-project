function [intervals, startCodes, stopCodes] = split2_events_bf(EEG)
events = [EEG.event.type];
latencies = [EEG.event.latency];
nanIndices = find(isnan(events));
latencies(nanIndices) = [];
events(nanIndices) = [];
intervals = [];
startIntervalIndex = 0;
startCodes = [];
stopCodes =  [];
for event = events
    startIntervalIndex = startIntervalIndex + 1;
    startIntervalLatency = latencies(startIntervalIndex);
    endIntervalLatencies = latencies(startIntervalIndex + 1: end); 
    for latency = endIntervalLatencies
        intervalDuration = (latency - startIntervalLatency)/EEG.srate;
%         assert(intervalDuration > 0); 
      if (25<intervalDuration) && (intervalDuration < 25.03) || (35 < intervalDuration) && ... 
            (intervalDuration < 35.03)|| (45 < intervalDuration) && (intervalDuration < 45.03)...
            || (70 < intervalDuration) && (intervalDuration < 70.03)  ...
            || (80 < intervalDuration) && (intervalDuration < 80.03) ||  (90 < intervalDuration) && ...
            (intervalDuration < 90.03)
        startCodes = [startCodes event];
        stopCodes = [stopCodes events(latencies == latency)];
        intervals = [intervals intervalDuration];
      end
    end
end

