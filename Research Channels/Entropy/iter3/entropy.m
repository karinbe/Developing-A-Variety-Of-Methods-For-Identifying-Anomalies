rng default; % For reproducibility


% Import the data:
[~, ~, raw] = xlsread('C:\Users\Hadas\Desktop\Diabetes.xls','Sheet1','A2:I769');

R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {2.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(data);

maxColumnsArray = zeros(1, columns-1);
for i = 1:columns-1
    maxVal = max(data(:,i));
    maxColumnsArray(i) = maxVal;
end

Hx = zeros(1,rows);

for i = 1:rows
  number = data(i,2);
  number2 = data(i,5);
  px = ProbabilityCalculation(number, maxColumnsArray(2))+ ProbabilityCalculation(number2, maxColumnsArray(5));
  Hx(i) = px * log10(1/px);
end

for i = 1:length(Hx)
    if Hx(i) < 0.1
        disp(i+1 + " is Anomaly.");
    end
end

clear;

% -------------------------------------------------------------------------
% Function that get a number, check its range
% and return the probability to be anomaly.
function p = ProbabilityCalculation(number, maxVal)
        p = number / maxVal;
end
