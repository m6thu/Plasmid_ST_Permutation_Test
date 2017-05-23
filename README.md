### Index of Contents

* [Dependencies](#dependencies) - r packages required and versioning
* [Method](#method) - algorithm used to perform this permutation test in diagrams
* [Data Structure](#data_structure) - data structure expected to use the functions given for this test
* [Files & Functions](#files_functions) - description of each files in repository and collection of comments from each function
* [Workflow](#workflow) - how the functions and data structures fit together
* [Validation](#validation) - proof that this test can be trusted
* [Example Scripts](#example_scripts) - basic example of usage

<a name ="dependencies"></a>

---------

### Dependencies 

Newer versions might work also, but these are timestop versions (as is when this test was created).

- plyr v1.8.4
- dplyr v0.5.0
- tidyr v0.6.3
- ggplot2 v2.2.1

To install current versions: `install.packages("plyr")`

If the current versions do not work, you may find their source codes under the packages folder in this repository.

To add r packages from source:

`install.packages(path_to_file, repos = NULL, type="source")`

or

`R CMD INSTALL package.tar.gz`

---------

<a name ="method"></a>

### Method 

What it does is, it looks for the likelihood of finding the same plasmid in different STs within the same patient. Potential horizontal transfer is defined as the likelihood of finding the same plasmid across other STs in the same patient. To quantify this, scoring for each patient and sample population is defined as such:

<center><img src="./images/horizontal_method_table_minus1.png" width="600"></center>

Each patient has some amount of STs, and multiple samples of each ST. Consider 1 to mean, in that sample the plasmid we are looking for is found, and 0 to mean not found. This can be used to consider phenotypes in the same way, 1 if phenotype is present, 0 if not. Because we only care whether an ST ever has the plasmid at any point in time or not, STs are OR across samples. 
 
A patient score is then calculated for each patient by simply finding the average of the result OR across samples minus 1 to both nominator and denominator. This gives us a score on the range of 0-1, where 0 means no plasmid is present in the patient in any ST, and 1 means the patient has the plasmid in question in all STs found in the patient.
 
A group score used to compare between the actual data and distribution of shuffled STs (n = 10,000) is calculated by finding the average score among only patients that have a patient score > 0 (has the plasmid at least once in some ST at some time). 
 
Permutation shuffling is done by only shuffling samples in their own ST as in the picture below.

<center><img src="./images/constrained_ST_shuffle.png" width="500"></center>

P-value is obtained from a one-tailed test.

---------

<a name ="data_structure"></a>

### Data Structure 

Example data structure expected. A cleaned version of phenotype and plasmid data used in this analysis can be found in the `data` folder.

<center><img src="./images/datastructure_plasmid.png" width="600"></center>

A data structure generated from one of the functions provided will look as such:

<center><img src="./images/datastructure_gen_annotated.png" width="350"></center>

More details on each function can be found under [Files & Functions](#files_functions) or in source.

---------

<a name ="workflow"></a>

### Workflow 

This section shows how each functions are meant to be used together in a workflow.

<center><img src="./images/workflow.png" width="600"></center>

---------

<a name ="files_functions"></a>

### Files & Functions 

This section contains descriptions for each file and function. These descriptions can also be found with each function source comment.

#### Files

<img src="./images/files_main.png" width="500">

<img src="./images/files_validation.png" width="600">

The only difference between `functions.R` and `p_functions.R` is the main function file returns a plot with p-value annotated on the plot, while the validation functions return a p-value numeric.

-------

#### Functions

**genfixedSTdf**

Generates a simple test dataframe with each patient having fixed number of STs, and a fixed number
of how many STs are missing the plasmid in a patient.

Args:  
  n_patients (int): Number of patients in entire data set  
  percent (int): Percentage of patients that will have the plasmid in a least 1 ST  
  n_avgST (int): Number of ST per patient  
  missing (int): Number of STs in a patient that will not have the plasmidNumber of STs in a patient that will not have the plasmid.  

Ex. n_patients = 5 percent = 80 n_avgST = 5 with missing = 3 would mean a dataframe with 5 patients
where 1 patient does not have the plasmid in any of their 5 STs. Remaining 4 patients would have 2 STs
with the plasmid and 3 STs missing the plasmid.  

Returns:  
  Nothing. Creates a global variable with the name f_p\<n_patients\>_c\<percent\>_s\<n_avgST\>_m\<missing\>.

**genNULLdf**

Generates a test dataframe where whether each ST for each patient has the plasmid or not,
is sampled from a binomial probability list given to the function.  

Args:  
  n_patients (int): Number of patients in entire data set  
  percent (int): Percentage of patients that will have the plasmid in a least 1 ST  
  n_avgST (int): Number of ST per patient  
  ST_probs (float): Vector of probabilities [0-1] for each ST. Length must be same value as n_avgST.  
                  Where ex. c(0.2, 0.3, 0.5) correspond to probabilities for ST1, ST2, ST3.  

Returns:  
  Nothing. Creates a global variable with the name n_p<n_patients>_c<percent>_s<n_avgST>.  

**genvarySTdf**

Generates a test dataframe with each patient having a mean value of STs with a standard deviation, and
a fixed number of how many STs are missing the plasmid in a patient.  

Args:  
  n_patients (int): Number of patients in entire data set  
  percent (int): Percentage of patients that will have the plasmid in a least 1 ST  
  n_ST_mean (float): Number of average STs per patient  
  n_ST_sd (float): Standard deviation of STs per patient  
  missing (int): Number of STs in a patient that will not have the plasmid  

Returns:  
  Nothing.
  Creates a global variable with the name v_p<n_patients>_c<percent>_s<n_ST_mean>_v<n_ST_sd>_n<missing>.  
  
**genrandomdf**

Generates a test dataframe with a fixed number of patients and STs per patient where presence of plasmid
is random.  

Args:  
  n_patients (int): Number of patients in entire data set  
  n_avgST (int): Number of ST per patient  

Returns:  
  Nothing.
  Creates a global variable with the name r_p<n_patients>_c<percent>_s<n_avgST>.  

**plasmidSTpermute**

Performs permutation test on dataframe given. Calls other non-data-generating functions by itself.  

Args:  
  plasmid_df (data.frame): A data frame with the following columns; idnum (patient), st (number), presence (binary). Or if columns exceed 3, it will drop 1st and 3rd column to try to get the 3 mentioned. See readme on data structures.  
  iterations (int): Number of times permutation is done to generate random distribution.  

Returns:  
  p (plot): plot result of permutation test  
  
**calcpatientscore**

Calculates patient score. Will be called by calcgroupscore function.  

Args:  
  plasmid (data.frame): A data frame with the following columns; idnum (patient), st (number), presence (binary). See readme on data structures.  

Returns:  
  patientscore (float): Vector of scores for each patient.  

**calcgroupscore**

Calculates group score. Will be called by plasmidSTpermute function.  

Args:  
  plasmid_df (data.frame): A data frame with the following columns; idnum (patient), st (number), presence (binary). See readme on data structures.  

Returns:  
  groupscore (float): Groupscore for dataframe.  


---------

<a name ="validation"></a>

### Validation 

Raw p-value distribution under the null hypothesis should be uniform.

<center><img src="./validation/proportion.png" width="350"></center>

The `validation` folder contains the entire body of work and method. See validation.Rmd and it's corresponding html file for a more detailed report.

---------

<a name ="example_scripts"></a>

### Example Scripts

More examples can found in TestResults.Rmd.

>iterations <- 1e3  
>plasmid <- select(whole_dataframe, c(1:5)) #only columns as described in data structure section  
>result <- plasmidSTpermute(plasmid, iterations)
