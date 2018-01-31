%--------------------------------------------------------------------------
% alfabeto = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M'
%             'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'W' 'Z'];
% The input mast contain numbers only. Otherwise, the value is converted to
% zero.
%--------------------------------------------------------------------------

rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\bm\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\src\table2.xlsx','גיליון1','A2:D16');
 
% Replace non-numeric cells with 0.0:
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {0.0}; % Replace non-numeric cells

% Create output variable:
dataAsNums = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(dataAsNums);

% Quantization level -
% Convert our data to string:
dataAsStr = '';
for i = 1:rows
    for j = 2:columns
        ascii = 65 + dataAsNums(i,j) / 10;
        if ascii < 65 % === if dataAsNums(i,j) < 0
            ascii = 65;
        elseif ascii > 90
            ascii = 90;
        end
        dataAsStr = strcat(dataAsStr,char(ascii));
    end
end


% Variables for LZ78 Algorithm:
[~, dataLength] = size(dataAsStr);
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

% Build & draw the tree:
nodes = zeros(1,dataLength); % Each cell contain the location of str(i) father + 1
for i = 1:dataLength
    nodes(i+1) = fatherLocation(i) + 1;
end

% organize = zeros(1,max(nodes)); % The real order of shows
% c = 1;
% for i = 1:dataLength
%     if organize(nodes(i+1)) == 0 % Only if this letter shows at the first time
%         organize(nodes(i+1)) = c;
%         c = c + 1;
%     end
% end

% counterSons = zeros(1,dataLength); % counterSons(i) is how many size letter i have
% for i = 1:dataLength
%     counterSons(nodes(i+1)) = counterSons(nodes(i+1)) + 1;
% end
% 
% copyCounterSons = zeros(1,dataLength); % Copy of counterSons. Starts with zeros and ends as counterSons
% for i = 1:dataLength
%     copyCounterSons(i) = 0;
% end

lzTree = {}; % Contain the finall tree
for i = 1:dataLength
    loc = 1;
    value = char(finallDict(i));
%    len = nodes(i+1);
%     binArr = zeros(1,max(nodes)); % Just to make sure that the change was done once and no more
%     for k = 1:max(nodes)
% %          If:
% %         1. Not the root of the tree
% %         2. Shows before our letter
% %         3. This is the first time
%         if organize(k) ~= 0 && organize(k) < organize(len) && binArr(organize(k)) == 0% && organize(nodes(k+1)) < organize(nodes(len+1))
%             loc = loc + counterSons(k);
%             binArr(organize(k)) = 1;
%             %disp("len = " + len + ", loc = " + loc);
%         end
%     end

    %onlyOnce = zeros(1,dataLength);
    for j = 1:dataLength
        lengthI = length(char(finallDict(i)));
        lengthJ = length(char(finallDict(j)));
        if (lengthJ < lengthI) || (lengthJ == lengthI && nodes(j+1) < nodes(i+1)) || (lengthJ == lengthI && nodes(j+1) == nodes(i+1) && j < i)
            loc = loc + 1;
        end
    end


    %loc = loc + copyCounterSons(len);
    
    %disp(loc);
    %disp("len = " + len + ", finLoc = " + loc);
    %disp(loc);
    %loc = findLocation(len, counterSons);
    lzTree(loc) = {value};
    %copyCounterSons(len) = copyCounterSons(len) + 1;
    %counterSons(len) = counterSons(len) - 1;
end

% disp(counterSons);
% disp("Dictionary: ");
% disp(finallDict);
%disp(nodes);
% view(lzTree);
% treeplot(nodes);
% disp("Lempel-Ziv Tree: ");
% disp(lzTree);

% -------------------------------------------------------------------------
% Function that get string, array of strings and the size of the array
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
