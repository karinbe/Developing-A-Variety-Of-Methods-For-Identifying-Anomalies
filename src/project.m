warning ('off','all')

rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\קארין\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\Tables\Diabeteswith01.xls','Sheet1','A2:I769');

% Deal with the values of the table which not numbers
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {2.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(data);
fprintf(1, '\n');

% Input integrity check (and training data)
counter = 0;
for i = 1:rows
    if data(i, columns) == 1
        counter = counter + 1;
    end
    if counter == 25
        break;
    end
end

if counter ~= 25
    disp("Error - small database");
    return
end

entropyArray = entropy(data, rows, columns);
LZArray = LZ(data, rows, columns);
MLarray = ML(data, rows, columns);

for i = 1:length(MLarray)-1
    if MLarray(i) + entropyArray(i) + LZArray(i) >= 2 % Anomaly
        disp("LINE " + i + " is Anomaly.")
    end
end