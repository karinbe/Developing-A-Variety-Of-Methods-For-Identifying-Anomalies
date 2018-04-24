Iteration 2 - Explanation:

Since the classification of normal and abnormal did not match expectations, we changed the quantum phase in the code:
In converting the table to a string, instead of converting the number by 10-digit ranges, as we did in the previous iteration, we set larger ranges in advance, and determined that each range would receive a letter at run time from the letters in the ABC order.
(Means, the range corresponding to the first number we observed was marked as 'a', the next range not yet shown is marked with 'b', and etc..)

The rest of the steps (dictionary construction, tree search) remain the same.