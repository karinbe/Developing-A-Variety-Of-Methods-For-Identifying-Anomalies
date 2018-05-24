rng default; % For reproducibility
 
% Import the data:
[~, ~, raw] = xlsread('C:\Users\�����\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\Diabeteswith01.xls','Sheet1','A2:I769');
 
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
  Hx(i) = (px * log10(1/px));
end
 
counterSS=0;
counterHS=0;
counterSH=0;
counterHH=0;

n=10;
giniIndexUp=0;
giniIndexDown=0;
for i=1: n
    for j=1:n
        giniIndexUp = giniIndexUp  + abs( Hx(i)-Hx(j) ) ;        
    end
    giniIndexDown= giniIndexDown+Hx(i);
end


found=0;
sum=0;
i=1;
while found<n
    if data(i,9)==1
        sum = sum + Hx(i);
        found=found+1;
        disp ("Hx(i)"+Hx(i) +" Sum"+ sum)
    end
    i=i+1;
end

average = sum/n;


standardDev = 0;
for x=1:i
    if data(x,9)==1
        standardDev = standardDev + power( Hx(x)-average ,2);
    end
end
 standardDev = sqrt(standardDev /n);

 
for i = 1:length(Hx)
    if Hx(i) < average+(standardDev*1)
%         disp(i+1 + " is Anomaly.");
        
        if data(i,9)==0
            counterSS=counterSS+1;
        else 
            counterHS=counterHS+1;
        end
    else
        if data(i,9)==0
             counterSH=counterSH+1;
        else
             counterHH=counterHH+1;
        end
    end 
end
 
good=counterSS+counterHH;
bad=counterHS+counterSH; 

disp ("We were right in "+ good + " cases" );
disp ("We were wrong in "+ bad + " cases");
giniIndex = giniIndexUp / (2*n*giniIndexDown);
% disp (giniIndex);
% disp ("average"+average);
%  disp (average+standardDev + "take1 with +");
%   disp (average+(standardDev*2) + "take2 with +");
%   disp (average+(standardDev*3) + "take3 with +");
%   disp (average-standardDev + "take4 with -");
%   disp (average-(standardDev*2) + "take5 with -");
%   disp (average-(standardDev*3) + "take6 with -");
%   
clear;
 
% -------------------------------------------------------------------------
% Function that get a number, check its range
% and return the probability to be anomaly.
function p = ProbabilityCalculation(number, maxVal)
        p = number / maxVal;
end



% 0.16562take1 with + (268 r  500w)
% 0.20496take2 with + 268
% 0.2443take3 with +  268
% 0.1 = >>>> 544
% 0.086948take4 with - 553
% 0.047611take5 with - 538
% 0.0082735take6 with -533



%     
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