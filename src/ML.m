rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\bm\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\src\table1.xlsx','גיליון1','A2:E11');
 
% Replace non-numeric cells with 0.0
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {0.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(data);

symbol = ['.', '+', '*', 'o', 's', 'd', 'v', '^', 'p', 'h', '<', '>'];

counter = 1; % Counter for the symbols

arrayCouter = zeros(1, rows); % arrayCouter[i] = how many times rows i analyzed as anomaly

RANGE = 0; % TODO(?)- What is our threshold for classifying?...

for i = 2:columns-1
    for j = i+1:columns
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
        
        figure;
        plot(matrix(idx==1,1),matrix(idx==1,2),strcat('r',symbol(counter)),'MarkerSize',6)
        hold on
        plot(matrix(idx==2,1),matrix(idx==2,2),strcat('b',symbol(counter)),'MarkerSize',6)
        %plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3)
        %legend('Cluster 1','Cluster 2','Centroids','Location','NW')
        title 'Cluster Assignments and Centroids'
        hold off
        
        counter = counter + 1;
        if counter == 13
            counter = 1;
        end
    end
end

average = mean(arrayCouter); % Average
median = median(arrayCouter); % Median

% Anomalies will be declared only in cases where the value is higher than both average and median
for i = 1:length(arrayCouter)
    if arrayCouter(i) > average && arrayCouter(i) > median
        disp(data(i,1) + " is Anomaly.");
    end
end