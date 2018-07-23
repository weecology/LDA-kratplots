#!/bin/bash

# Job name and who to send updates to
#SBATCH --job-name=<ldatrial>
#SBATCH --mail-user=<diaz.renata@ufl.edu>
#SBATCH --mail-type=ALL

# Where to put the outputs: %j expands into the job number (a unique identifier for this job)
#SBATCH --output ldatrial%j.out
#SBATCH --error ldatrial%j.err

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=8gb   # Per processor memory
#SBATCH --cpus-per-task=4
#SBATCH --time=03:00:00   # Walltime

#Record the time and compute node the job ran on
date;hostname; pwd

#Use modules to load the environment for R
module load R

Rscript run-hg.R

