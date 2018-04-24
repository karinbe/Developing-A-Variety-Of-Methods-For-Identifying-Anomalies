rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\bm\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\table2.xlsx','גיליון1','A2:D16');

R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {2.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(data);

H = zeros(1,rows);

for i = 1:rows
    for j = 2:columns
        number = data(i,j);
        if number >= 0 && number < 60 
            p = 0.025;
        elseif number >= 60 && number < 80
            p = 0.075;
        elseif number >= 80 && number < 150
            p = 0.1;
        elseif number >= 150 && number < 200
            p = 0.3;
        else
            p = 0.5;
        end
        H(i) = H(i) + (p * log10(1/p));
    end
end

average = mean(H); % Average
median = median(H); % Median

% Anomalies will be declared only in cases where the value is higher than both average and median
for i = 1:length(H)
    if H(i) > average && H(i) > median
        disp(data(i,1) + " is Anomaly.");
    end
end

clear;