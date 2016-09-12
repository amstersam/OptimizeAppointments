This is a sample series of scripts to find a schedule that minimizes both 
the expected total waiting times of the patients, and the expected total 
idle time of a doctor (GI/G/1 queue model).
Input file --> "input" as example

Step 1 - Run DistFit and DistPlot to identify the distribution of the arrivals

Step 2 - Run CalcTimes and CalcTimesPlot to estimate the expected total waiting times.

Step 3 - Run OptTimes, Weighted_OptTimes and OptTimesPlot to minimize idle and waiting 
times for differents cases and various methods.