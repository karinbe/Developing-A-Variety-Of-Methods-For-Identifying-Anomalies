rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\Hadas\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\table2.xlsx','גיליון1','A2:D16');

R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {2.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(data);

Hx = zeros(1,rows-1);
Hy = zeros(1,rows-1);
Hxy = zeros(1,rows-1);

arrayCouter = zeros(1, rows); % arrayCouter[i] = how many times rows i analyzed as anomaly

for i = 1:rows-1
    for j = 2:columns

        number = data(i,j);
        px = ProbabilityCalculation(number);
        Hx(i) = Hx(i) + (px * log10(1/px));

        py = ProbabilityCalculation(data(i+1,j));
        Hy(i) = Hy(i) + (py * log10(1/py));
        
        pxy = ProbabilityCalculation(number + data(i+1,j));
        Hxy(i) = Hxy(i) + (pxy * log10(1/pxy));
        
    end
    
  parametr1 = Hxy(i)-Hx(i);
  parametr2 = Hxy(i)-Hy(i);
  
  if parametr1 < parametr2
      arrayCouter(i) = arrayCouter(i) + 1;
  elseif parametr1 > parametr2
      arrayCouter(i+1) = arrayCouter(i+1) + 1;
  end
end

% Anomalies will be declared only in cases where the value is 2
for i = 1:length(arrayCouter)
    if arrayCouter(i) == 2
        disp(data(i,1) + " is Anomaly.");
    end
end

clear;

% -------------------------------------------------------------------------
% Function that get a number, check its range
% and return the probability to be anomaly.
function p = ProbabilityCalculation(number)
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
end
