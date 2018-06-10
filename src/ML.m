rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\�����\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\Diabeteswith01.xls','Sheet1','A2:I769');

R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {2.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(data);

symbol = ['.', '+', '*', 'o', 's', 'd', 'v', '^', 'p', 'h', '<', '>'];

counter = 1; % Counter for the symbols

arrayCouter = zeros(1, rows); % arrayCouter[i] = how many times rows i analyzed as anomaly

RANGE = 0;

for i = 1:columns-1
    for j = i+1:columns-1
        matrix = [data(:,i), data(:,j)]; % This matrix always have 2 rows - i and j
        status = 0; % Who is bigger - group 1 or group 2
        
%         figure;
%         plot(matrix(:,1), matrix(:,2), strcat('k',symbol(counter)));
%         title 'Randomly Generated Data';
        
        opts = statset('Display','final');
        [idx,C] = kmeans(matrix,2,'Distance','cityblock',...
            'Replicates',1,'Options',opts);
        
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
        
%         figure;
%         plot(matrix(idx==1,1),matrix(idx==1,2),strcat('r',symbol(counter)),'MarkerSize',6)
%         hold on
%         plot(matrix(idx==2,1),matrix(idx==2,2),strcat('b',symbol(counter)),'MarkerSize',6)
%         %plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3)
%         %legend('Cluster 1','Cluster 2','Centroids','Location','NW')
%         title 'Cluster Assignments and Centroids'
%         hold off
        
        counter = counter + 1;
        if counter == 13
            counter = 1;
        end
    end
end

average = mean(arrayCouter); % Average
median = median(arrayCouter); % Median

counterSS = 0;
counterHS = 0;
counterSH = 0;
counterHH = 0;

% Anomalies will be declared only in cases where the value is higher than both average and median
for i = 1:length(arrayCouter)
    if arrayCouter(i) > average && arrayCouter(i) > median
    %if arrayCouter(i) > 10
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

good = counterSS + counterHH;
bad = counterHS + counterSH;
disp ("We were right in "+ good + " cases" );
disp ("We were wrong in "+ bad + " cases");


clear;