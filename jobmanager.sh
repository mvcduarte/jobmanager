#!/bin/bash
#
# PROCMANAGER
# Costa-Duarte, M.V. - 2011
#
echo '****************************************************'
echo 
echo 'Hi, human!'
echo 'Welcome to the PROCMANAGER!'
echo
echo  '                  M. V. Costa-Duarte - 12/02/2013'
echo 
echo '****************************************************'

# Number of running processes at the same time

#read run
run=$1
file_code=$2
fileproc=$3

#file_code='Starlight_v04_Mac.exe'
#fileproc='list_processes'

echo 'number of processes at the same time:' $run
echo 

# List of processes

echo 'list of processes:' $fileproc
nproc=`wc -l "$fileproc" | awk '{print $1'}`
echo 'nproc='$nproc
procin=[]
procin=($(cat "$fileproc" | awk '{print $1'})) # array
echo

# Code

echo 'code:' $file_code

# Generating a "random" string

str0=$$
POS=2  # Starting from position 2 in the string.
LEN=10  # Extract eight characters.
str1=$(pwgen -s 10 1)
string="${str1:$POS:$LEN}_"
echo 'Random string='$string
echo 

# Copying the files of executable compiled code

for i in $(seq 0 $(($nproc-1)) )
do
 cp $file_code $string$i.out
done

# Running the first $run processes  

echo 'Start running the jobs..'

n=0
for i in $(seq 0 $(($run-1)) )
do
filerun[$i]="$string$i.out"
proc="$string$i.out"
echo $i ${procin[$i]} 'started!'
./$proc < ${procin[$i]} > output_${procin[$i]} &
#
if [ "$i" -lt "$((run-1))" ]
then  
n=$((n+1))
fi
sleep 2
done

# Starting the loop until the condiction is done..

cond=0
while [ "$cond" != 1 ]
do
# Getting the PID of running processes
nrun=0
norun=0
g=[]
for i in $(seq 0 $((run-1)) )
do
pid=`ps -ef | grep ${filerun[$i]} | \
grep -v grep | cut -c1-6`

if [ ! -z $pid ] 
then
 g[$i]=1
 nrun=$((nrun+1))
# echo 'check: running...' $i 
else
 filenorun[$norun]=${filerun[$i]}
 g[$i]=0
fi

done

# Is it necessary to run other processes?
for i in $(seq 0 $((run-1)) )
do

# Number of running processes < run at the same time
if [ "$nrun" -lt "$run" ]
then

# Number of processes finished or running < number total of processes
if [ "$n" -lt "$((nproc-1))" ] 
then 
n=$((n+1))
proc="$string$n.out"
echo 'starting new job..' ${procin[$n]}
./$proc < ${procin[$n]} > output_${procin[$n]} &
nrun=$(($nrun+1))
#
# Putting the new running process in the array filerun
ok=0
for j in $(seq 0 $((run-1)) )
do 
if [ "${g[$j]}" -eq "0" ]
then 
if [ "$ok" -eq "0" ]
then 
filerun[$j]=$proc
g[$j]=1
ok=1
fi
fi
done
#
fi
fi
#
done
#
#
if [ "$n" -eq "$((nproc-1))" ] # Number of processes finished or running < number total of processes
then 
norun=0
nrun=0
for i in $(seq 0 $((run-1)) )
do
pid=`ps -ef | grep ${filerun[$i]} | \
grep -v grep | cut -c1-6`
if [ ! -z $pid ] 
then
 nrun=$((nrun+1))
fi
done
if [ "$nrun" -eq "0" ] 
then
 cond=1
fi
fi
#
sleep 2
done
rm $string*.out
echo 'Finished!  =)'
date
exit 0