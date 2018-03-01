## JOB MANAGER

This bash script is a manager to run a list of jobs in a sequence, being "n" jobs at the same time.
It is useful when one has to run a list of jobs but you want to manage this list according to the number of processors you keep available to run them. 

# SYNTAX

For instance, if you want to run the code Starlight.exe using a list of input files (list_processes) and using only 2 processes at the same time, then you just type:

./jobmanager.sh 2 Starlight.exe list_processes

The list_processes is

grid_example1.in 
grid_example2.in 
grid_example3.in
...

# WARRANTY

The script will automatically show in the terminal the new jobs which just started while the old ones were finished.

WARRANTY: This script is ONLY tested on Bash 3.2 on Mac. Please, test this script using a short list of processes to not overflow your processor. :)
