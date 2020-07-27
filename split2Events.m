function [startCodes, c, EEG] = split2Events(EEG)
eventsCounter = 0;
startCodes = [];
short = false;
for i = EEG.setname
    if i == 'x'
        short = true;
        break
    end
end
if short == true
    disp('short');
    tempEEG = EEG;
    events = [EEG.event.type];
    latencies = [EEG.event.latency];
    nanIndices = find(isnan(events));
    latencies(nanIndices) = [];
    events(nanIndices) = [];
    latencies = round(latencies);
    c = cell(1,3);
    cellCount = 1;
    for i = events
        eventsCounter = eventsCounter + 1;
        truncEvents = events(eventsCounter+1:end);
        event7080StopList = find(truncEvents == 80 | truncEvents == 70);
        if isempty(event7080StopList)
            event7080StopList = 0;
        end
        data = EEG.data(:, latencies(eventsCounter): latencies(eventsCounter + event7080StopList(1))-1);
        intervalDuration = size(data,2)/EEG.srate;
        if (25<intervalDuration) && (intervalDuration < 25.03) || (35<intervalDuration) &&  ... 
           (intervalDuration<35.03) || (45<intervalDuration) && (intervalDuration<45.03) 
        c{cellCount} = data;
        cellCount = cellCount + 1;
        startCodes = [startCodes i];
        clear data;
        end
    end
    EEG  = createNewEEG(EEG,c);
else
    tempEEG = EEG;
    events = [EEG.event.type];
    latencies = [EEG.event.latency];
    nanIndices = find(isnan(events));
    latencies(nanIndices) = [];
    latencies = round(latencies);
    events(nanIndices) = [];
    c = cell(1,6);
    cellCount = 1;
    for i = events
        eventsCounter = eventsCounter +1;
        truncEvents = events(eventsCounter+1:end);
        event3020StopList = find(truncEvents == 30 | truncEvents == 20);
        if isempty(event3020StopList)
            event3020StopList = 0;
        end 
        data = EEG.data(:, latencies(eventsCounter): latencies(eventsCounter + event3020StopList(1))-1);
        intervalDuration = size(data,2)/EEG.srate;
        if (25<intervalDuration) && (intervalDuration < 25.03) || (35 < intervalDuration) && ... 
            (intervalDuration < 35.03)|| (45 < intervalDuration) && (intervalDuration < 45.03)...
            || (70 < intervalDuration) && (intervalDuration < 70.03)  ...
            || (80 < intervalDuration) && (intervalDuration < 80.03) ||  (90 < intervalDuration) && ...
            (intervalDuration < 90.03)
        c{cellCount} = data;
        cellCount = cellCount + 1;
        startCodes = [startCodes i]; 
        clear data;
        end
    end
    EEG = createNewEEG(EEG,c);
end
