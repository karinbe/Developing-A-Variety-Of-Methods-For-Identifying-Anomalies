Entropy:

Iteration 1 - Explanation:
 
Reading the data from the Excel table. Convert any cell that is not a number to 0 and converts the data from table to matrix.
 

We then defined each range in the matrix according to the Shannon formula (H). For this purpose, we defined the same ranges as we defined in the Lempel-Ziv method, and for each range we assigned a different probability - the probability of being ill (to identify as an anomaly).

In the next stage, after each line has been given an entropy value, the average and median entropy will be calculated.
Finally, a patient will be defined as an abnormal for entropy values greater than the average and also the median.