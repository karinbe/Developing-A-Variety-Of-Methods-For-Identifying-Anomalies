function entropyArray = entropy(data, rows, columns)

% t0 = clock;

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

% % GINI index: TODO delete??
% giniIndexUp = 0;
% giniIndexDown = 0;
% for i=1: n
%     for j=1:n
%         giniIndexUp = giniIndexUp  + abs(Hx(i) - Hx(j)) ;
%     end
%     giniIndexDown = giniIndexDown + Hx(i);
% end
% giniIndex = giniIndexUp / (2*n*giniIndexDown);

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
disp (PercentageOfSuccess + "%");
% disp( "counterSS "+ counterSS);
% disp( "counterHH "+ counterHH);
% disp( "counterHS "+ counterHS);
% disp( "counterSH "+ counterSH);
% good = counterSS + counterHH;
% bad = counterHS + counterSH;
% disp ("We were right in "+ good + " cases");
% disp ("We were wrong in "+ bad + " cases");
% TODO delete all of this:
% disp (giniIndex);
% disp ("average"+average);
% disp (average+standardDev + "take1 with +");
% disp (average+(standardDev*2) + "take2 with +");
% disp (average+(standardDev*3) + "take3 with +");
% disp (average-standardDev + "take4 with -");
% disp (average-(standardDev*2) + "take5 with -");
% disp (average-(standardDev*3) + "take6 with -");

% ms = round(etime(clock,t0) * 1000);
% disp("Run time of entropy (ms): " + ms);

end

% -------------------------------------------------------------------------
% Function that get a number, check its range
% and return the probability to be anomaly.
function p = ProbabilityCalculation(number, maxVal)
p = number / maxVal;
end

% TODO delete all of this:
% 0.16562take1 with + (268 r  500w)
% 0.20496take2 with + 268
% 0.2443take3 with +  268
% 0.1 = >>>> 544
% 0.086948take4 with - 553
% 0.047611take5 with - 538
% 0.0082735take6 with -533

% TODO old version - delete ?
%     for j = 1:columns-1
%
%         number = data(i,j);
%         px = ProbabilityCalculation(number, maxColumnsArray(j));
%         Hx(i) = Hx(i) + (px * log10(1/px));
%
%     end

%     number = data(i,2);
%     px = ProbabilityCalculation(number, maxColumnsArray(2));
%     Hx(i) = px * log10(1/px);
%
%     number = data(i,5);
%     px = ProbabilityCalculation(number, maxColumnsArray(5));
%     Hx(i) = Hx(i) + (px * log10(1/px));