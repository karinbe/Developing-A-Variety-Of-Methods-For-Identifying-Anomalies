%--------------------------------------------------------------------------
% alfabeto = ['a' - 'z']
% The input mast contain numbers only. Otherwise, the value is converted to
% zero.
%--------------------------------------------------------------------------

rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\קארין\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\Diabeteswith01.xls','Sheet1','A2:I769');

% Replace non-numeric cells with 0.0:
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {0.0}; % Replace non-numeric cells

% Create output variable:
dataAsNums = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(dataAsNums);
% Quantization level -
% Convert our data to string:
dataAsStr = ''; % A string which hold the table's values
trainingDataAsStr = ''; % A string which hold the training data's values
arrRange = cell(1,6); % range of the different cell's types
ascii = 97; % the small char 'a', helps to catalog cell's types
index = 1; % indicator in arrArange

n = 400; % Arbitrary selection of the amount of training data
found = 0; % Training data - n first healthy

maxColumnsArray = zeros(1, columns-1); % Contains the highest value of each column
for i = 1:columns-1
    maxVal = max(dataAsNums(:,i));
    disp(maxVal);
    maxColumnsArray(i) = maxVal;
end

average = mean(dataAsNums,1);  % Contains the average of each column

for i = 1:rows
%     index = findIndexByRange(dataAsNums(i,2));
%     if isempty(arrRange{index})
%         arrRange{index} = ascii;
%         ascii = ascii + 1;
%     end
%     if found < n && dataAsNums(i,columns) == 1
%         trainingDataAsStr = strcat(trainingDataAsStr,char(arrRange{index}));
%     else
%         dataAsStr = strcat(dataAsStr,char(arrRange{index}));
%     end
%     
%     index = findIndexByRange(dataAsNums(i,5));
%     if isempty(arrRange{index})
%         arrRange{index} = ascii;
%         ascii = ascii + 1;
%     end
%     if found < n && dataAsNums(i,columns) == 1
%         trainingDataAsStr = strcat(trainingDataAsStr,char(arrRange{index}));
%     else
%         dataAsStr = strcat(dataAsStr,char(arrRange{index}));
%     end


    
    for j = 1:columns-1
        index = findIndexByRange(dataAsNums(i,j));
        %index = findIndexByRange(dataAsNums(i,j));
        if isempty(arrRange{index})
            arrRange{index} = ascii;
            ascii = ascii + 1;
        end
        
        if found < n && dataAsNums(i,columns) == 1
            trainingDataAsStr = strcat(trainingDataAsStr,char(arrRange{index}));
        else
            dataAsStr = strcat(dataAsStr,char(arrRange{index}));
        end
    end
    if dataAsNums(i,columns) == 1
        found = found + 1;
    end
end

disp(dataAsStr);
disp(trainingDataAsStr);

% Variables for LZ78 Algorithm:
[~, dataLength] = size(trainingDataAsStr);
dict = cell(1,dataLength); % Dictionary
fatherLocation = zeros(1,dataLength);
currentString = '';
currentDictIndex = 1;

% Build the dictionary:
for i = 1:dataLength
    currentString = strcat(currentString,trainingDataAsStr(i));
    index = isFound(currentString, dict, currentDictIndex);
    if index == 0 % If currentString isn't in the dictionary
        dict(currentDictIndex) = {currentString};
        currentDictIndex = currentDictIndex + 1;
        currentString = '';
    else
        fatherLocation(currentDictIndex) = index;
    end
end

% Finall dictionary, without empty cells ('dict' contains empty cells for efficiency):
dataLength = currentDictIndex - 1;
finallDict = cell(1,dataLength);
for i = 1:currentDictIndex-1
    finallDict(i) = dict(i);
end

disp(finallDict);

% Build & draw the tree:
nodes = zeros(1,dataLength); % Each cell contain the location of str(i) father + 1
for i = 1:dataLength
    nodes(i+1) = fatherLocation(i) + 1;
end

lzTree = {dataLength}; % Contain the finall tree
for i = 1:dataLength
    loc = 1;
    value = char(finallDict(i));
    for j = 1:dataLength
        lengthI = length(char(finallDict(i)));
        lengthJ = length(char(finallDict(j)));
        if (lengthJ < lengthI) || (lengthJ == lengthI && nodes(j+1) < nodes(i+1)) || (lengthJ == lengthI && nodes(j+1) == nodes(i+1) && j < i)
            loc = loc + 1;
        end
    end

    lzTree(loc) = {value};
end



% Search:
[~, testingDataLength] = size(dataAsStr);
howManyTimes = testingDataLength / (columns - 1); % How many times the loop will run
startPos = 1;
endPos = columns - 1;

for i = 1:howManyTimes
    stringToSearch = extractBetween(dataAsStr,startPos,endPos);
    if ~ismember(stringToSearch , lzTree)
        p = (startPos - 1)/(columns - 1) + 1;
        disp(p + ": '" + stringToSearch + "' is Anomaly.");
    end
    startPos = startPos + columns - 1;
    endPos = endPos + columns - 1;
end





clear;
% -------------------------------------------------------------------------
% Function that get a string, array of strings and the size of the array
% and check if the string appears inside the array or not.
% If so, return the index. Otherwise, return zero.
function fatherIndex = isFound(currentString, dict, currentDictIndex)
    for i = 1:currentDictIndex
        if strcmp(currentString,dict(i))
            fatherIndex = i;
            return
        end
    end
    fatherIndex = 0;
end
% -------------------------------------------------------------------------
function index = findIndexByRange(number) % TODO get average and stdev.p)
    if number < (57.7499)
        index = 1;
    elseif number >= (57.7499) && number < 83.86495
        index = 2;
    elseif number >= 83.86495 && number < 109.98
        index = 3;
    elseif number >= 109.98 && number < 136.09505
        index = 4;
    elseif number >= 136.09505  && number < 162.2101
        index = 5;
    else % number >=162.2101
        index = 6;
    end
end
