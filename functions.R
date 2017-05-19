### Functions for permutation test

library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)

######################## Generate data with fixed ST number per patient ######################
# Generates a simple test dataframe with each patient having fixed number of STs, and a fixed number 
# of how many STs are missing the plasmid in a patient.
#
# Args:
#   n_patients (int): Number of patients in entire data set
#   percent (int): Percentage of patients that will have the plasmid in a least 1 ST
#   n_avgST (int): Number of ST per patient
#   missing (int): Number of STs in a patient that will not have the plasmidNumber of STs in a patient that will not have the plasmid. 
#
# Ex. n_patients = 5 percent = 80 n_avgST = 5 with missing = 3 would mean a dataframe with 5 patients 
# where 1 patient does not have the plasmid in any of their 5 STs. Remaining 4 patients would have 2 STs
# with the plasmid and 3 STs missing the plasmid.
#
# Returns:
#   Nothing. Creates a global variable with the name f_p<n_patients>_c<percent>_s<n_avgST>_m<missing>.

genfixedSTdf <- function(n_patients, percent, n_avgST, missing){
    n_ST = rep(n_avgST, n_patients)
    idnum <- vector()
    plasmid <- vector()
    patients <- 1:n_patients
    st <- vector()
    
    for(i in 1:n_patients){
        idnum <- c(idnum, rep(patients[i], n_ST[i]))
        st <- c(st, 1:n_ST[i])
        
        if (i <= n_patients*(percent/100) && n_ST[i] >= missing){
            plasmid <- c(plasmid, rep(1, n_ST[i]-missing))
            plasmid <- c(plasmid, rep(0, missing))
        }else{
            plasmid <- c(plasmid, rep(0, n_ST[i]))
        }
    }
    idnum <- paste("ID", idnum, sep="")
    var_name <- paste("f_", "p", n_patients, "c", percent,"_s", n_avgST, "m", missing, sep = "")
    assign(var_name, data.frame(idnum, st, plasmid), envir = .GlobalEnv)
}

############################# Generate NULL hypothesis ####################################
# Generates a test dataframe where whether each ST for each patient has the plasmid or not,
# is sampled from a binomial probability list given to the function.
#
# Args:
#   n_patients (int): Number of patients in entire data set
#   percent (int): Percentage of patients that will have the plasmid in a least 1 ST
#   n_avgST (int): Number of ST per patient
#   ST_probs (float): Vector of probabilities [0-1] for each ST. Length must be same value as n_avgST. 
#                   Where ex. c(0.2, 0.3, 0.5) correspond to probabilities for ST1, ST2, ST3.
#
# Returns:
#   Nothing. Creates a global variable with the name n_p<n_patients>_c<percent>_s<n_avgST>.

genNULLdf <- function(n_patients, percent, n_avgST, ST_probs){
    
    n_ST = rep(n_avgST, n_patients)
    idnum <- vector()
    plasmid <- vector()
    patients <- 1:n_patients
    st <- vector()
    
    for(i in 1:n_patients){
        idnum <- c(idnum, rep(patients[i], n_ST[i]))
        st <- c(st, 1:n_ST[i])
        
        if (i <= n_patients*(percent/100)){
            for(j in 1:n_ST[i]){
                plasmid <- c(plasmid, rbinom(1, 1, ST_probs[j]))
            }
        }else{
            plasmid <- c(plasmid, rep(0, n_ST[i]))
        }
    }
    
    idnum <- paste("ID", idnum, sep="")
    var_name <- paste("n_", "p", n_patients, "c", percent,"_s", n_avgST, sep = "")
    assign(var_name, data.frame(idnum, st, plasmid), envir = .GlobalEnv)
}

############## Generate data with ST number varied around mean per patient #####################
# Generates a test dataframe with each patient having a mean value of STs with a standard deviation, and 
# a fixed number of how many STs are missing the plasmid in a patient.
#
# Args:
#   n_patients (int): Number of patients in entire data set
#   percent (int): Percentage of patients that will have the plasmid in a least 1 ST
#   n_ST_mean (float): Number of average STs per patient
#   n_ST_sd (float): Standard deviation of STs per patient
#   missing (int): Number of STs in a patient that will not have the plasmid
#
# Returns:
#   Nothing. 
#   Creates a global variable with the name v_p<n_patients>_c<percent>_s<n_ST_mean>_v<n_ST_sd>_n<missing>.

genvarySTdf <- function(n_patients, percent, n_ST_mean, n_ST_sd, missing){
    n_ST = round(rnorm(n_patients, n_ST_mean, n_ST_sd))
    #n_ST = rep(n_avgST, n_patients)
    # TODO: Add/Think of way to handle 0 STs
    idnum <- vector()
    plasmid <- vector()
    patients <- 1:n_patients
    st <- vector()
    
    for(i in 1:n_patients){
        idnum <- c(idnum, rep(patients[i], n_ST[i]))
        st <- c(st, 1:n_ST[i])
        
        if (i <= n_patients*(percent/100) && n_ST[i] >= missing){
            plasmid <- c(plasmid, rep(1, n_ST[i]-missing))
            plasmid <- c(plasmid, rep(0, missing))
        }else{
            plasmid <- c(plasmid, rep(0, n_ST[i]))
        }
    }
    idnum <- paste("ID", idnum, sep="")
    var_name <- paste("v_", "p", n_patients, "c", percent,"_s", n_ST_mean, "v", n_ST_sd, "m", missing, sep = "")
    assign(var_name, data.frame(idnum, st, plasmid), envir = .GlobalEnv)
}

############################# Generate random plasmids #################################
# Generates a test dataframe with a fixed number of patients and STs per patient where presence of plasmid
# is random.
#
# Args:
#   n_patients (int): Number of patients in entire data set
#   n_avgST (int): Number of ST per patient
#
# Returns:
#   Nothing. 
#   Creates a global variable with the name r_p<n_patients>_c<percent>_s<n_avgST>.

genrandomdf <- function(n_patients, n_avgST){
    n_ST = rep(n_avgST, n_patients)
    idnum <- vector()
    plasmid <- vector()
    patients <- 1:n_patients
    st <- vector()
    for(i in 1:n_patients){
        idnum <- c(idnum, rep(patients[i], n_ST[i]))
        st <- c(st, 1:n_ST[i])
        plasmid <- c(plasmid, rbinom(n_ST[i], 1, 0.5))
    }
    idnum <- paste("ID", idnum, sep="")
    var_name <- paste("r_", "p", n_patients,"_s", n_avgST, sep = "")
    assign(var_name, data.frame(idnum, st, plasmid), envir = .GlobalEnv)
}

####################### Permutation Test Functions#########################
# Performs permutation test on dataframe given. Calls other non-data-generating functions by itself.
#
# Args:
#   plasmid_df (data.frame): A data frame with the following columns; idnum (patient), st (number), 
#                           presence (binary). Or if columns exceed 3, it will drop 1st and 3rd column 
#                           to try to get the 3 mentioned. See readme on data structures.
#   iterations (int): Number of times permutation is done to generate random distribution.
#
# Returns:
#   p (plot): plot result of permutation test

plasmidSTpermute <- function(plasmid_df, iterations){
    # Save original name
    plasmid_new_df <- plasmid_df
    
    # Clean raw data for shuffling (moved from calc patient scores)
    # sort by idnum
    plasmid_new_df <- plasmid_new_df[order(plasmid_new_df$idnum),]
    
    if(length(names(plasmid_new_df)) > 3){
        plasmid_new_df <- select(plasmid_new_df, -c(1,3))
    }
    # rename columns to not be dependent on plasmid name
    names(plasmid_new_df) <- c("idnum", "st", "plasmid")
    
    # convert idnum into factor for grouping
    plasmid_new_df$idnum <- as.factor(plasmid_new_df$idnum)
    plasmid_new_df$st <- as.factor(plasmid_new_df$st)
    
    # get list of all samples grouped by patient, ordered by sample name
    plaslist <- split(plasmid_new_df, plasmid_new_df$idnum)
    
    for (i in 1:length(plaslist)){
        #print (i)
        # if there are repeats of ST
        if(length(unique(plaslist[[i]]$st)) < length(plaslist[[i]]$st)){
            # save idnum
            id_tmp <- plaslist[[i]]$idnum
            # OR each ST
            plaslist[[i]] <- aggregate(plaslist[[i]]$plasmid, by=list(st=plaslist[[i]]$st), FUN=sum)
            plaslist[[i]]$x <- replace(plaslist[[i]]$x, plaslist[[i]]$x > 0, 1)
            names(plaslist[[i]]) <- c("st", "plasmid")
            # put idnum back and reorder back the same
            plaslist[[i]]$idnum <- id_tmp[1:nrow(plaslist[[i]])]
            plaslist[[i]] <- plaslist[[i]][c("idnum","st","plasmid")]
            rownames(plaslist[[i]]) <- make.names(rownames(plaslist[[i]]), unique=TRUE)
        }
    }
    # put list back as data frame
    #unsplit(plaslist, unique(plasmid_new_df[,1:2])$idnum)
    plasmid_new_df <- do.call(rbind, plaslist)
    
    # calculate group score as is
    data_score <- calcgroupscore(plasmid_new_df)
    
    shuffle_score <- vector(length = iterations)
    # for iterations times given
    for (i in 1:iterations){
        #plasmid_shuffle <- plasmid_new_df
        
        # Constrain shuffle with only same STs between IDs (introduces NAs)
        plasmid_shuffle <- spread(plasmid_new_df, st, plasmid)
        # Test data
        #plasmid_shuffle$`1` <- c(11, 12, 13, 14, 15)
        #plasmid_shuffle$`2` <- c(21, 22, 23, 24, 25)
        #plasmid_shuffle$`3` <- c(31, 32, 33, 34, 35)
        #plasmid_shuffle$`4` <- c(41, 42, 43, 44, 45)
        #plasmid_shuffle$`5` <- c(51, 52, 53, 54, 55)
        for(j in 2:ncol(plasmid_shuffle)){
            plasmid_shuffle[, j][!is.na(plasmid_shuffle[, j])] = sample(plasmid_shuffle[, j][!is.na(plasmid_shuffle[, j])])
        }
        plasmid_shuffle <- gather(plasmid_shuffle, "st", "plasmid", -1)
        # Remove NAs
        plasmid_shuffle <- plasmid_shuffle[!is.na(plasmid_shuffle$plasmid),]
        
        # calculate group score per shuffle
        shuffle_score[i] <- calcgroupscore(plasmid_shuffle)
    }
    
    # calculate one-sided p-value
    p_value <- sum(shuffle_score >= data_score, na.rm=TRUE)/iterations
    print_pvalue <- paste0("P-value: ", p_value)
    title <- paste0("Data: ", substitute(plasmid_df))
    title <- paste(title, print_pvalue, sep="     ")
    #print(title)
    
    # plot shuffled group scores histogram, line at input group score
    p <- qplot(shuffle_score, geom ="histogram") + 
        geom_vline(aes(xintercept = data_score, color = "red")) +
        labs(title = title)

    return(p)
}

#################### Calculate Patient Score Vector (Horizontal Transmission) ######################
# Calculates patient score. Will be called by calcgroupscore function.
#
# Args:
#   plasmid (data.frame): A data frame with the following columns; idnum (patient), st (number), 
#                           presence (binary). See readme on data structures.
#
# Returns:
#   patientscore (float): Vector of scores for each patient.

calcpatientscore <-function(plasmid){ #plasmid dataframe
    
    plaslist <- split(plasmid, plasmid$idnum)
    
    patientscore <- vector()
    for (i in 1:length(plaslist)){
        
        if(nrow(plaslist[[i]]) > 1){
            patientscore[i] <- (sum(plaslist[[i]]$plasmid)-1)/(nrow(plaslist[[i]])-1)
        }else{
            patientscore[i] <- NA
        }
    }
    
    return(patientscore)
}

######################## Calculate Group Score ##########################
# Calculates group score. Will be called by plasmidSTpermute function.
#
# Args:
#   plasmid_df (data.frame): A data frame with the following columns; idnum (patient), st (number), 
#                           presence (binary). See readme on data structures.
#
# Returns:
#   groupscore (float): Groupscore for dataframe.

calcgroupscore <- function(plasmid_df){
    patientscore <- calcpatientscore(plasmid_df)
    
    # patients that do not have the plasmid in question at all do not get to vote
    patientscore <- replace(patientscore, patientscore == 0, NA)
    voters <- patientscore[!is.na(patientscore)]
    
    groupscore <- sum(voters)/length(voters)
    if(is.na(groupscore)){
        #print(length(voters))
    }
    return(groupscore)
}