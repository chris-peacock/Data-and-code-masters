# Data processing code masters

This repository is to back up all my matlab code, for my master's thesis analysis pipeline. 
The <b>standard_analysis</b> script calls several other scripts to process and eventually save the data to a workspace:

## data_read
  *inputs = (directory path, shape of data array, position of indexing characters, lines to skip in file read)
  
  *outputs a 5-D data array, 
  size = (#of samples,
          #of strain increments,
          #of ROI,2 (for x,y axes),
          #of datapoints (must be > than the max # of datapoints, fill rest with NaNs))
          
  *outputs a list of files from which the data was read, for keeping track of files missing/potential typos in filenames

## mean_std
  *inputs = (data)
  
  *outputs mean and standard deviation along the datapoint (5th) axis of 'data_read' output
  
## fourier_profile
  *inputs = (data,# of points in linear interpolation, size of local average,low freq cutoff,high freq cutoff,plot? (bool),checkfourier     (bool))
  
  *outputs real-space period corresponding to the peak in the fourier transform in the frequency region between low and high freq cutoff,
  size = (#of samples,
          #of strain increments,
          #of ROI)
  
  *outputs mask for frequency peak array, each entry is 0 or 1 depending on user input (check to see whether peak of profile was found        correctly)
  
  *outputs array of root mean square of average-subtracted input data
  
## hiprint
 *inputs = (file path, file name, DPI for output image)
 
 *outputs image of stated DPI
 

  
  
