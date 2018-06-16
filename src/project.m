rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\Hadas\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\letter-unsupervised.xlsx','letter-unsupervised-ad (2)');

R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {2.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(data);

entropyArray = entropy(data, rows, columns);
fprintf(1, '\n');
LZArray = LZ(data, rows, columns);
fprintf(1, '\n');
MLarray = ML(data, rows, columns);
fprintf(1, '\n');
counterSS = 0;
counterHS = 0;
counterSH = 0;
counterHH = 0;

for i = 1:length(MLarray)-1
    if MLarray(i) + entropyArray(i) + LZArray(i) >= 2 % Anomaly
        %disp(i + " is anomaly.")
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
disp("Majorty Vote:");
PercentageOfSuccess = (counterSS + counterHH) / rows;
PercentageOfSuccess = PercentageOfSuccess * 100;
disp (PercentageOfSuccess + "%");
good = counterSS + counterHH;
bad = counterHS + counterSH;
% disp("counterSS: " + counterSS);
% disp("counterSH: " + counterSH);
% disp("counterHS: " + counterHS);
% disp("counterHH: " + counterHH);
% disp ("We were right in "+ good + "% from the cases" );
% disp ("We were wrong in "+ bad + " cases");
