###Index

Dependencies - r packages required and versioning
Method - algorithm used to perform this permutation test in diagrams
Data Structure - data structure expected to use the functions given for this test
Files & Functions - description of each files in repository and collection of comments from each function
Workflow - how the functions and data structures fit together
Validation - proof that this test can be used
Example Scripts - basic example of usage

###Dependencies (check if true dependency)

Newer versions might work also, but these are the versions as is when this test was created.
- plyr 
- dplyr 
- tidyr 
- ggplot2 

If the current versions do not work, you may find their source codes under the packages folder in this repository.

To add r packages from source try:
`install.packages(path_to_file, repos = NULL, type="source")`
or
`R CMD INSTALL package.tar.gz`


###Method

This section describes the algorithm used to perform this permutation test in diagrams.

[Scoring]

[Shuffling]

What it does is, it looks for the likelihood of finding the same plasmid in different STs within the same patient.


###Data Structure

[data structure w/ context]

[data structure w/o context]

[generated data structures]


###Workflow

This section shows how each functions are meant to be used together in a workflow.

[Workflow]


###Files & Functions

This functions contains descriptions for each file and function. These descriptions can also be found with each function source comment.

functions.R

p_functions.R

validation.Rmd



###Validation

This section goes over why we can trust this test.



###Example Scripts