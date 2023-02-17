**Notice:** *As of the beginning of 2023 the Data Accessioner project no longer has any active developers maintaining it.*

XSLT Processor
==============

Simple GUI tool for running a set of xslt over a set of source files.

The default set of xslt are intended to transform the output of files from the 
Data Accessioner versions 3.1 (using the PREMIS metadata manager), 1.0, and 1.1.

# Usage

+ Double-click the Jar
+ Use the "Add Source" button to add source files (DA output files)
+ Use the "Add Transform"  button to add transforms (xslt files that generate the reports)
    + By convention all xslt files should include the destination file extension in the file name (e.g. the default report creates CSV files and so has the extension ".csv.xslt").
+ Use the "Remove" buttons to remove the sources and transforms you don't want.
+ Use the "Set Output Dir" button to select where the reports will be saved OR type a path into the box provided.
    + By default all the reports found in the accompanying "xslt" folder are added
    + Two report transform are distributed with the tool:  CSV and HTML
+ Click "Run Transforms" when you are ready
    + Reports appear in the destination directory and named by the corresponding source and report file names.
    + Status messages will appear in the big text box as it runs
    + Currently only setup and completion messages are included

# TODO

+ Implement the cancel button
+ Update the files csv report for more intelligent format handling.
+ Create additional reports
    + summary report counting the number of files, the total file volume, counting the number of various file types identified, etc
    + Simile Timeline <http://www.simile-widgets.org/timeline/> of the file and folder last modified dates
