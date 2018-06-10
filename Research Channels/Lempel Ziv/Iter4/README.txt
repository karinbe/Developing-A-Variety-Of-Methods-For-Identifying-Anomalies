Lempel Ziv

Iteration 4 - Explanation:

At this stage, we attempted to perform the quantization using the mean and maximum value of each column: the four ranges by which we divided the data into letters were based on the distance of the data from the mean and the maximum value of the relevant column.

Quantization in this manner did not seem particularly successful, apparently because the test data was longer than the depth of the tree; Therefore, in the next iteration we will focus on a different quantization and not necessarily apply it to all the columns in the table, but only to the "most influential" columns whose distribution is similar to the normal distribution.