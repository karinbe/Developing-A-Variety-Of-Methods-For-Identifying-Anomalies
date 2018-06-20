Iteration 1 - Explanation:

Reading the data from the Excel table. Convert each cell that is not a number to 0 and converts the data from table to matrix.

Next step, go over each column pair in the matrix, and run a k-means algorithm. This algorithm classifies the data into different groups. In our study, the algorithm is calculated with k = 2 in order to classify the participants into two different groups: the larger group will be the normal data, and the smaller group will be the anomaly. At this stage, if the difference between the two groups is particularly small, indicating that the combination of these two columns does not indicate much of which lines are normal behavior and who is anomaly, the result is omitted and we did not add it to our calculations. If the division into two groups is unequivocal, the lines have been identified as anomaly.

In the last stage - after we finished all the columns, we calculated the average number of times a line would classify as an anomaly, and the median. A line will be identified as an anomaly case when the number of times he is classified as an anomaly is greater than both the average and the median.

That is the last iteration before the final development (which in the src file).