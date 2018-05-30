rng default; % For reproducibility
 
% Import the data:
[~, ~, raw] = xlsread('C:\Users\קארין\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\Diabeteswith01.xls','Sheet1','A2:I769');
 
 R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
 raw(R) = {2.0}; % Replace non-numeric cells
 
% Create output variable:
data = reshape([raw{:}],size(raw));
 
% Find out data size:
[rows, columns] = size(data);
 
maxColumnsArray = zeros(1, columns-1); % Contains the highest value of each column
for i = 1:columns-1
    maxVal = max(data(:,i));
    maxColumnsArray(i) = maxVal;
end
 
Hx = zeros(1,rows); % Contains the entropy of each row

% Calculating entropy based on the most influential columns:
for i = 1:rows
    px=0;
    for j=1 : columns-1
        number = data(i,j);
        px = px + ProbabilityCalculation(number, maxColumnsArray(j));
    end 
  Hx(i) = (px * log10(1/px));
end
 
% Counting our success and failure
% The counters in the following format: counter<sick or healthy in reality><We saw whether sick or healthy>
counterSS = 0;
counterHS = 0;
counterSH = 0;
counterHH = 0;

n = 10; % Arbitrary selection of the amount of training data

found = 0; % Training data - n first healthy
sum = 0; % Sum of n first healthy
i = 1;
while found < n
    if data(i,columns) == 1
        sum = sum + Hx(i);
        found = found + 1;
    end
    i = i + 1;
end

average = sum / n; % Average of the n first healthy

standardDev = 0; % Standard deviation
for x = 1:i
    if data(x,columns) == 1
        standardDev = standardDev + power(Hx(x)-average ,2);
    end
end
standardDev = sqrt(standardDev / n);

% Finding anomalies and the counters:
for i = 1:length(Hx)
    if Hx(i) < average - (standardDev * 1)
        disp(i+1 + " is Anomaly.");
        if data(i,columns) == 0
            counterSS = counterSS + 1;
        else 
            counterHS = counterHS + 1;
        end
    else
        if data(i,columns) == 0
             counterSH = counterSH + 1;
        else
             counterHH = counterHH + 1;
        end
    end 
end

% In what we were right and wrong:
good = counterSS + counterHH;
bad = counterHS + counterSH;
disp ("We were right in "+ good + " cases" );
disp ("We were wrong in "+ bad + " cases");

clear;
 
% -------------------------------------------------------------------------
% Function that get a number, check its range
% and return the probability to be anomaly.
function p = ProbabilityCalculation(number, maxVal)
        p = number / maxVal;
end