function LZarray = LZ(data, rows, columns)

global NUM_OF_RANGE
NUM_OF_RANGE = 8;

LZarray = zeros(1, rows+1); % The array that the function return
LZarrayCounter = zeros(1, rows); % An array that calculates for each row the number of times it is classified as anomaly.

n = 25; % Arbitrary selection of the amount of training data TODO
found = 1; % Training data counter
countMode = 0; % Count the number of Normal distribution - that is, the number of columns with which we will work.

trainingDataArr = zeros(1,n); % An array for the training data
trainingDataCounter = 1; % Index in the 'trainingDataArr' array's

% Save in trainingDataArr :
for i = 1:rows
    if data(i,columns) == 1
        trainingDataArr(trainingDataCounter) = i;
        trainingDataCounter = trainingDataCounter + 1;
        found = found + 1;
    end
    if found > n
        break;
    end
end

% Convert the training data to string:
for i = 1:columns-1
    columnStrTraining = ''; % A string that represents a column in the training data
    arrRange = cell(1,NUM_OF_RANGE); % range of the different cell's types TODO
    ascii = 97; % the small char 'a', helps to catalog cell's types
    trainingDataColumnArr = zeros(1,n); % Array that coantain the values of the column
    for index = 1:n % (Each column has its own data)
        trainingDataColumnArr(index) = data(trainingDataArr(index), i);
    end
    
    aveSend = mean(trainingDataColumnArr); % average
    stdevSend = std(trainingDataColumnArr); % Standard deviation
    med = median(trainingDataColumnArr); % Median
    common = mode(trainingDataColumnArr); % The most common value in the column
    
    if abs(aveSend - med) < 10 && abs(aveSend - common) < 10 && abs(med - common) < 10 % if mode~mean~median
        countMode = countMode + 1;
        
        % Quantization for traning data and create 'columnStrTraining':
        for r = 1:n
            arrRangeIndex = quantization(trainingDataColumnArr(r), aveSend, stdevSend); % indicator in arrArange
            if isempty(arrRange{arrRangeIndex})
                arrRange{arrRangeIndex} = ascii;
                ascii = ascii + 1;
            end
            columnStrTraining = strcat(columnStrTraining,char(arrRange{arrRangeIndex}));
        end
        
        % Fill cell's values in ranges that not in the training data
        for x = 1:NUM_OF_RANGE
            if isempty(arrRange{x})
                arrRange{x} = ascii;
                ascii = ascii + 1;
            end
        end
        
        % Next step - Dictionary
        
        % Variables for LZ78 Algorithm:
        dict = cell(1,n); % Dictionary
        fatherLocation = zeros(1,n);
        currentString = '';
        currentDictIndex = 1;
        
        % Build the dictionary:
        for p = 1:n
            currentString = strcat(currentString,columnStrTraining(p));
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
        dictLen = currentDictIndex - 1;
        finallDict = cell(1,dictLen);
        for p = 1:currentDictIndex-1
            finallDict(p) = dict(p);
        end
        
        % Build the tree:
        nodes = zeros(1,dictLen); % Each cell contain the location of str(i) father + 1
        for x = 1:dictLen
            nodes(x+1) = fatherLocation(x) + 1;
        end
        
        %        LZ TREE in order of levels:
        lzTree = {dictLen}; % Contain the finall tree
        for p = 1:dictLen
            loc = 1;
            value = char(finallDict(p));
            for x = 1:dictLen
                lengthI = length(char(finallDict(p)));
                lengthJ = length(char(finallDict(x)));
                if (lengthJ < lengthI) || (lengthJ == lengthI && nodes(x+1) < nodes(p+1)) || (lengthJ == lengthI && nodes(x+1) == nodes(p+1) && x < p)
                    loc = loc + 1;
                end
            end
            
            lzTree(loc) = {value};
        end
        
        % Next step - Search:
        place = 1; % Index in the array of the training data
        for j = 1:rows
            if place <= n && j == trainingDataArr(place)
                place = place + 1;
            else
                arrRangeIndex = quantization(data(j,i), aveSend, stdevSend); % indicator in arrArange
                stringToSearch = char(arrRange{arrRangeIndex});
                % check if the value is not in the tree
                if ~ismember(stringToSearch , lzTree)
                    LZarrayCounter(j) = LZarrayCounter(j) + 1;
                end
            end
        end
    end
end

for x = 1:rows
    if LZarrayCounter(x) >= countMode-1
        LZarray(x+1) = 1;
    end
end
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

% -------------------------------------------------------------------------
% The step of the quantization.
% The function get a numeric value for a cell, an average of the
% relevant column and the standard deviation of the relevant column,
% and returns the appropriate index in the array
% that represents the letters according to the ranges.
function index = quantization(number, ave, stdev)
global NUM_OF_RANGE
NUM_OF_RANGE = 8;
range = 2 * stdev / NUM_OF_RANGE;

if number < ave - stdev
    index = 1;
elseif number >= ave - stdev && number < ave - stdev + range
    index = 2;
elseif number >= ave - stdev + range && number < ave - stdev + (2 * range)
    index = 3;
elseif number >= ave - stdev + (2 * range) && number < ave - stdev + (3 * range)
    index = 4;
elseif number >= ave - stdev + (3 * range)  && number < ave - stdev + (4 * range)
    index = 5;
elseif number >= ave - stdev + (4 * range) && number < ave - stdev + (5 * range)
    index = 6;
elseif number >= ave - stdev + (5 * range)  && number < ave - stdev + (6 * range)
    index = 7;
else % === if number >= ave - stdev + (6 * range)
    index = 8;
end
end