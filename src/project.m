rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\קארין\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\Diabeteswith01.xls','Sheet1','A2:I769');

R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {2.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

[~, columns] = size(data);

entropyArray = entropy(data);

MLarray = ML(data);

LZArray = LZ(data);

counterSS = 0;
counterHS = 0;
counterSH = 0;
counterHH = 0;

for i = 1:length(MLarray)-1
    if MLarray(i) + entropyArray(i) + LZArray(i) >= 2 % will be sick for sure
        disp(i + " is anomaly.")
        if data(i,columns) == 0 % TODO cols..
            counterSS = counterSS + 1;
        else
            counterHS = counterHS + 1;
        end
    else
        if data(i,columns) == 0 % TODO cols..
            counterSH = counterSH + 1;
        else
            counterHH = counterHH + 1;
        end
    end
end

% In what we were right and wrong:
good = counterSS + counterHH;
bad = counterHS + counterSH;
disp("Majorty Vote");
disp("counterSS: " + counterSS);
disp("counterSH: " + counterSH);
disp("counterHS: " + counterHS);
disp("counterHH: " + counterHH);
disp ("We were right in "+ good + " cases" );
disp ("We were wrong in "+ bad + " cases");
