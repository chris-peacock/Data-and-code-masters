*Extension analysis pipeline*

plotbasic_inport_height/mod:

Imports all height and modulus data from a single sample set of 
images (provided all profiles are in same directory), find the average of each profile and s.d.
These values plotted versus machine strain and versus fibril strain (imported from another file),
files saved to directory through path unique to my file system.  Files imported into this program have 
the naming format "SE##_fib#_#strain_#", where '#' represent sample number, fibril number, machine strain
value, region number respectively.  Program is set up to perform profile analysis on images with 5% strain
increments in name; can include strain values to skip by altering 'strainskip' value. set strainskip = -1
to avoid skipping any strains in analysis.  height/modulus values are saved per region (and region av)
in respective files 'h_average.txt','m_average.txt'.  each row of datafile is a region, each col a strain

plotbasic_import_dbandFFT:

Similar import process to plotbasic_inport_height/mod (same files to import), however this program FFTs
the imported profiles and searches for a frequency peak in the 10-20 (1/um) range (corresponding to dband)
Plots frequency positions of peaks as a function of machine strain and saves a datafile of all peak values

plotbasic_trapz_crosssec:

Similar import process to plotbasic_inport_height/mod (same files to import), however this numerically
integrates imported crossection profiles and saves this value as a cross sectional area.  These values are
plotted versus machine strain and are saved to a datafile, similar to plotbasic_import_dbandFFT


plotbasic_SE16_example:

Program intended to plot cross section and dband values versus machine strain and fibril strain for a 
single sample. dlim_m and clim_m are the upper limits set for plotting dband and cross sectional area.
This program is used just for plotting calculated results

