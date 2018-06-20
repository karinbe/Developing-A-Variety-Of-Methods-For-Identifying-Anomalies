function entropyArray = entropy(data, rows, columns)

t0 = clock;

maxColumnsArray = zeros(1, columns-1); % Contains the highest value of each column
for i = 1:columns-1
    maxVal = max(data(:,i));
    maxColumnsArray(i) = maxVal;
end

entropyArray = zeros(1,rows+1);
Hx = zeros(1,rows); % Contains the entropy of each row

% Calculating entropy for esch row:
for i = 1:rows
    for j = 1:columns-1
        number = data(i,j);
        px = ProbabilityCalculation(number, maxColumnsArray(j));
        if px ~= 0
            Hx(i) = Hx(i) + (px * log10(px));
        end
        
    end
    Hx(i) = Hx(i) * (-1);
end

% Counting our success and failure
% The counters in the following format: counter<sick or healthy in reality><We saw whether sick or healthy>
counterSS = 0;
counterHS = 0;
counterSH = 0;
counterHH = 0;

n = 10; % Arbitrary selection of the amount of training data

% Finding the split rule:
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
    if Hx(i) > average + (1 * standardDev)
        %         disp(i+1 + " is Anomaly.");
        entropyArray(i+1) = 1;
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
disp ("Entropy:");
PercentageOfSuccess = (counterSS + counterHH) / rows;
PercentageOfSuccess = PercentageOfSuccess * 100;
disp ("Success Percentage of the Method: "+PercentageOfSuccess + "%");

ms = round(etime(clock,t0) * 1000);
disp("Run time of entropy (ms): " + ms);

end

% -------------------------------------------------------------------------
% Function that get a number, check its range
% and return the probability to be anomaly.
function p = ProbabilityCalculation(number, maxVal)
p = number / maxVal;
end