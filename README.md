# SIFT-FV-4.0
Paper based implementation of facial recognition task using SIFT and Fisher Vector Encoding 

Reference: https://www.robots.ox.ac.uk/~vgg/publications/2013/Simonyan13/simonyan13.pdf

Preperation: 
1. Download LFW dataset at http://vis-www.cs.umass.edu/lfw/lfw.tgz
2. Make base folder in your pc (eg: YOUR_FOLDER)
3. Extract LFW dataset to your base folder (eg: YOUR_FOLDER->lfw)
4. Download and Install Matlab (version R2015a used in developing)
5. Download vl_feat toolbox for Matlab at http://www.vlfeat.org/download/vlfeat-0.9.20-bin.tar.gz
6. Extract vl_feat toolbox at base folder (eg: YOUR_FOLDER->vlfeat)
7. Copy-paste these program code to your base folder
8. [Optional learned model] Download .mat files in this link: http://bit.ly/LFW_5112100086 be aware that the model that I learned using 192 K-Gaussian separated in two folders (each two folds) and need to be copy-pasted in base folder in order to do testing process, or you can modify the code if needed :).   
9. place the .mat files in one folder [bigfiles] to your pc (could be in base folder or not, later will be manually selected)

Running:
1. Run startup.m than choose filepath of base folder containing the code and [bigfiles] folder location
2. Run main.m (running line-by-line is recommended)
3. If you encounter problems, make sure the filepath in your PC synchronized with the code.
