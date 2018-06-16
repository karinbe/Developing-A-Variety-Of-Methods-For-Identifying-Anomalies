function MLarray = ML(data, rows, columns)

MLarray = zeros(1, rows+1); % The array that the function return

arrayCouter = zeros(1, rows); % arrayCouter[i] = how many times rows i analyzed as anomaly

RANGE = 100; % threshold for classifying

for i = 1:columns-1
    for j = i+1:columns-1
        matrix = [data(:,i), data(:,j)]; % This matrix always have 2 rows - i and j
        
        [idx,~] = kmeans(matrix,2,'Distance','cityblock','Replicates',2);
        
        %             opts = statset('Display','final');
        %             [idx,~] = kmeans(matrix,2,'Distance','cityblock',...
        %                 'Replicates',2,'Options',opts);
        
        status = 0; % Who is bigger - group 1 or group 2
        % Check which group is bigger:
        for k = 1:length(idx)
            if idx(k) == 1
                status = status + 1;
            else % idx(k) == 2
                status = status - 1;
            end
        end
        
        % Set the status by the small group:
        if status > RANGE
            status = 2;
        elseif status < RANGE * (-1)
            status = 1;
        else
            status = 0; % The test is not counted
        end
        
        % Add the amonalies to arrayCouter:
        for k = 1:length(idx)
            if idx(k) == status
                arrayCouter(k) = arrayCouter(k) + 1;
            end
        end
    end
end

average = mean(arrayCouter); % Average
med = median(arrayCouter); % Median

% Anomalies will be declared only in cases where the value is higher than both average and median
for i = 1:length(arrayCouter)
    if arrayCouter(i) > average +(columns/10) && arrayCouter(i) > med + (columns/10)
        MLarray(i+1) = 1;
    end
end

counterSS = 0;
counterHS = 0;
counterSH = 0;
counterHH = 0;

% Anomalies will be declared only in cases where the value is higher than both average and median
for i = 1:length(arrayCouter)
    if arrayCouter(i) > average +(columns/10) && arrayCouter(i) > med + (columns/10)
        %disp(i+1 + " is Anomaly.");
        MLarray(i+1) = 1;
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

disp ("Machine Learning:");
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

end