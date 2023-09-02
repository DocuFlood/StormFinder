# StormFinder
This code could help to find the storms among the rainfall data. In particular, it is desinged to find the SCS type II cumulative curve. 
### Description of the code: 
The potential challenge would appear when you want to find the storms among a large dataset (e.g. 60 years of data with an interval of 15 mins), the main code (stormfinder.m) needs a CSV file of your data including only one column (i.e. Rainfall data). You only need to adjust the date in stormfinder.m and then run it. A tutorial video is available here to show how this code works. It should point out that this code is set to find the 6 hours storms that normally are more intense consequalntly, they could generate the storms closer to the type II of SCS curves. 
 


% Load the CSV file
inputFilename = 'Keynsham-rainfall-15min-Qualified.csv';
outputFilename = 'ModifiedData.txt'; % Change the file extension to .txt

% Read the table with headers
data = readtable(inputFilename, 'HeaderLines', 1); % Skip the first row as header

% Specify the column indices to remove (A=1, B=2, C=3, etc.)
columnsToRemove = [1, 2, 3, 5, 6, 7, 8];

% Remove the specified columns
data(:, columnsToRemove) = [];

% Replace NaN values in Column A with 0
data{isnan(data{:, 1}), 1} = 0;

% Convert the table to a cell array
dataCell = table2cell(data);

% Save the modified data (without specified columns and with NaN replaced by 0) to a new text file
delimiter = '\t'; % Use tab as the delimiter for a text file
writetable(cell2table(dataCell), outputFilename, 'Delimiter', delimiter, 'WriteVariableNames', false);

disp('Specified columns removed, NaN values replaced with 0, modified data saved to ModifiedData.txt');
