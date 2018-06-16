Iteration 4 - Explanation:
 
In this iteration, we focused on changing the terms of the decision, which until now had been 0.1 based on the calculations that corresponded to the specific table with which we work, to a general condition that is determined on the data screen only at the time of the run.

For this purpose, we took a certain amount of "training data" of normal behavior lines only (for that matter, 10 lines), and in order to achieve the best result, we tried several methods:

At first we tried the Gini Index method, which included a mathematical formula to which we sent the entropy values of the normal behavior lines, whose outcome would be the decisive condition.

We calculated the mean of the entropy of the training data, and then their standard deviation. For the test described below, we summarized four things: normal lines that classified as normal behavior, normal lines that classified as anomaly, anomaly lines that classified as normal behavior and anomaly lines classified as anomaly.
Then, based on the scientific graph of the normal distribution percentages around the mean (symmetry axis) by standard deviations, we examined which of the ranges would give the best results, assuming that most normal behavior lines would enter this range while the anomaly lines did not: average +/- 1/2 / 3 times the standard deviation, and for each of them we tested our success rate. The test of the average - 1 times the standard deviation gave the highest success rate, so we chose it.

Of these two methods (distribution and Gini index), the first method provided the best results, so we decided to stick to it.

After changing the terms of the decision, we turned the calculation of entropy into more rules - instead of the calculation being made on the most influential columns, it was done on all the columns. We ran this on the terms of the new decision, and we achieved identical results and even better than the calculation of the previous entropy. Just for testing, we again examined the ranges of +/- 1/2/3 times the standard deviation, this time on the new entropy - and in this test, the mean-1 test was twice as high as the standard deviation gave the highest success rate.
