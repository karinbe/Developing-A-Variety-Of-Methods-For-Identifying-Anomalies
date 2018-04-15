%--------------------------------------------------------------------------
% alfabeto = ['a' - 'z']
% The input mast contain numbers only. Otherwise, the value is converted to
% zero.
%--------------------------------------------------------------------------

rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\÷àøéï\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\tables\table2.xlsx','âéìéåï1','A2:D16'); 
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
arrRange = cell(1,5); % range of the different cell's types
ascii = 97; % the small char 'a', helps to catalog cell's types
index = 1; % indicator in arrArange

for i = 1:rows
    for j = 2:columns  
        number = dataAsNums(i,j);
        if number >= 0 && number < 60 
            index = 1;
        elseif number >= 60 && number < 80
            index = 2;
        elseif number >= 80 && number < 150
            index = 3;
        elseif number >= 150 && number < 200
            index = 4;
        else
            index = 5;
        end
            
        if isempty(arrRange{index})
            arrRange{index} = ascii;
            ascii = ascii + 1;
        end

        dataAsStr = strcat(dataAsStr,char(arrRange{index}));
    end
end

disp(dataAsStr);

[~, dataLength] = size(dataAsStr);

LengthOfAllData = dataLength;
dataLength = 10 * (columns - 1); % const - we arbitrarily chose 10 lines
SearchStartIndex = dataLength + 1;

% Variables for LZ78 Algorithm:
dict = cell(1,dataLength); % Dictionary
fatherLocation = zeros(1,dataLength);
currentString = '';
currentDictIndex = 1;

% Build the dictionary:
for i = 1:dataLength
    currentString = strcat(currentString,dataAsStr(i));
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

lzTree = {}; % Contain the finall tree
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
howManyTimes = (LengthOfAllData - SearchStartIndex + 1) / (columns - 1);% How many times the loop will run
startPos = SearchStartIndex;
endPos = SearchStartIndex + columns - 2;
for i = 1:howManyTimes
    stringToSearch = extractBetween(dataAsStr,startPos,endPos);
    if ~ismember(stringToSearch , lzTree)
        disp(dataAsNums((startPos - 1)/(columns - 1) + 1, 1) + " ('" + stringToSearch + "') is Anomaly.");
    end
    startPos = startPos + columns - 1;
    endPos = endPos + columns - 1;
end


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