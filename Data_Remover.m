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
