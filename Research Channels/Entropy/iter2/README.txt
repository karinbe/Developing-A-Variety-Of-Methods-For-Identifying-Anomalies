Iteration 2 - Explanation:
 
In this iteration, we calculated the entropy for each row and the entropy shared for each two rows (the probability function remained unchanged from the previous iteration).
The resolution of what will be defined as an anomaly is determined by comparing the two lines. For each line we calculated the difference between the shared entropy and the entropy of the row only, and the row with the lower difference would be suspicious as an anomaly.
Then, instead of focusing on the average and the median as we did in the previous iteration, we decided that a line that was suspected twice would be an anomaly.
