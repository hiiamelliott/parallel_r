# Parallel R
A project to illustrate how multiple R scripts can be run in parallel in Domino.

## Introduction
### Problem
> I have multiple, independent tasks I want to run in parallel– how can I do that in Domino?

In general, distributed compute is a great way to pool the memory and processing resources from multiple machines, to improve the performance of running multiple tasks at the same time.  
Domino supports workloads that connect to distributed compute frameworks, such as Dask, Ray, Spark, and OpenMPI.   
It also supports autoscaling distributed compute clusters, meaning that it can start up servers as demand for resources rises, and shut them down as demand falls. 

This has the joint benefits of:
1. Reducing waiting times for tasks that could be running in parallel.
2. Reducing costs compared to running 1 large server with the capacity to run all of the tasks in parallel, which then sits underutilised as the shorter tasks end.

However, R has fewer binaries that allow the use of distribute compute frameworks than Python.  
Also, distributed compute frameworks have specific applications and can't be used for everything.  
So what can we do in Domino to support multiple R tasks running in parallel in Domino?

## Demo Project
This project takes the example of a computer game where there is a collection of cars, various parts, drivers and team principals.
* Each part, driver and team principal has a variety of attributes, including a weight of "R&D Points".
* Each car can have 10 parts, 1 driver and 1 team principal, and a maximum of 100 R&D Points.
* Parts are divided into 5 categories, and cars can use any parts they want, but only 2 parts from each category can be used on a car at a time.
* No two cars can have the same driver or team principal.
* It's essentially a knapsack problem.

This project breaks the process down into 3 steps:
1. `setups.R` reads a CSV of parts, splits them into categories, cleans the data, and then works out the best combinations of 2 parts for each category.  
   It then works out the best arrangement of those combinations, sorts them by total points, and writes the output to a CSV file in a dataset that can be read by the following steps.

2. `aio.R`  fits each setup into a car, then multiplies the attributes by those of each team principal, and ensures that there are enough R&D points left over to add a driver too.
   For each car, these combinations are again sorted by points and written to a CSV file in the dataset.

3. `compare.R` reads the CSVs exported by the previous step and finds the arrangement of drivers and team principals that returns the most total points.

### In Series
Working out the ideal setup for each car would take a long time if we calculated them in series.  
Assuming that step 2 takes 5 minutes per car, and there are 11 cars, the whole process could easily take an hour.

### In Parallel
Instead, we can use one of the `launch` scripts to request that Domino runs `aio.R` for each car in parallel.  
`launch.py` uses Domino's Python client to launch a collection of jobs (one for each car) using its `domino.job_start()` function.  
`launch.R` demonstrates making calls to Domino's REST API to achieve the same result.  
Running the jobs in step 2 in parallel, it's reasonable to expect this to reduce the time for the whole process down from 1 hour to around 15 minutes.

As all of the jobs take the same amount of time, they should roughly stop at the same time.  
However, in a case where some jobs took longer than others, the servers running the shorter jobs would shut down as they finish, leaving only the longer jobs running.  
This frees up resources for other tasks and reducing costs vs running one, large server for everything. 

### Custom Hardware Tiers
Again, as all of the jobs in our demo are identical, they would take the same amount of time and require the same amount of server resources.  
However, a feature was built into the `launch` scripts in the demo that reads in a CSV of Domino hardware tier names and IDs.  
More demanding jobs could run on larger servers, while less demanding jobs can run on smaller hardware tiers, using resources more efficiently.

