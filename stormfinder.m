%% Load the CSV file (replace 'Chew-Magna-Spillway-rainfall-15min-Qualified.csv' with your file path)
rainfall = csvread('Chew-Magna-Spillway-rainfall-15min-Qualified.csv');

% Calculate the number of data points in a 6-hour window (15 minutes * 24 data points)
dataPointsInWindow = 6 * 60 / 15;

% Initialize arrays to store cumulative rainfall and top indices
cumulativeRainfall = zeros(1, length(rainfall) - dataPointsInWindow + 1);
topIndices = zeros(1, length(rainfall) - dataPointsInWindow + 1);

%% Calculate cumulative rainfall using a loop
for i = 1:length(rainfall) - dataPointsInWindow + 1
    cumulativeRainfall(i) = sum(rainfall(i:i + dataPointsInWindow - 1));
end

% Find the indices of the rainfall events
[~, topIndices] = sort(cumulativeRainfall, 'descend');

% Create a cell array to store the top 20 events' data
topEventsData = cell(20, 3);
datesConsidered = {}; % Keep track of dates already considered

% Fill in the cell array with event data
numEventsAdded = 0; % Count of events added
i = 1; % Index for topIndices
while numEventsAdded < 20 && i <= length(topIndices)
    startIndex = topIndices(i);
    endIndex = startIndex + dataPointsInWindow - 1;
    startTime = datetime('2011-10-01T00:00:00', 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss') + (startIndex - 1) * minutes(15);
    
    % Check if the date has already been considered
    currentDate = datestr(startTime, 'yyyy-mm-dd');
    if ~ismember(currentDate, datesConsidered)
        datesConsidered = [datesConsidered; currentDate]; % Add date to considered list
        
        % Calculate end time, rainfall value, and update counters
        endTime = startTime + hours(6);
        rainfallValue = cumulativeRainfall(startIndex);
        
        topEventsData{numEventsAdded + 1, 1} = datestr(startTime);
        topEventsData{numEventsAdded + 1, 2} = datestr(endTime);
        topEventsData{numEventsAdded + 1, 3} = sprintf('%.2f', rainfallValue);
        
        numEventsAdded = numEventsAdded + 1;
    end
    
    i = i + 1;
end

%% Define the header
header = {'StartTime', 'EndTime', 'Rainfall_mm'};

%% Combine header with data
outputData = [header; topEventsData];

%% Create a table from the cell array
outputTable = cell2table(outputData(2:end, :), 'VariableNames', outputData(1, :));

%% Write the table to an Excel file
filename = 'Top_20_Rainfall_Events.xlsx';
writetable(outputTable, filename, 'Sheet', 1, 'WriteVariableNames', true);

disp(['Top 20 6-hour rainfall events saved to "', filename, '".']);
