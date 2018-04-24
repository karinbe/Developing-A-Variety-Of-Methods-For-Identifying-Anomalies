Iteration 1 - Explanation:

Reading the data from the Excel table. Converts any cell that is not a number to 0 and converts the data from table to matrix.

We then quantified and converted the numeric data into a string, with each cell in the table represented by a letter.
The way we converted the number into a string was that each range of 10 numbers was converted to the same letter - any number less than 0 converted to A, numbers between 0 and 10 converted to B, numbers between 10 and 20 converts to C, further. Numbers whose value is greater than Z are converted to Z.
So we converted the whole table into one long string.
The next thing we did was separate the training data used to construct the tree and the testing data on which the tests were conducted.
We decided to choose that the first 10 lines build the model, and the rest will be checked.

To build the model, we went over the first part of the string (containing the first 10 lines), and on it we performed the process of constructing the dictionary, and the process of building a tree for the waterfall - Ziv accordingly.

Then, when we had a built-in tree, we went through the rest of the lines.
We examined each part of a string representing a row and compared it to the tree.
A row that appeared in a tree was classified as normal, whereas a line that did not appear in the tree was classified as anomaly.
