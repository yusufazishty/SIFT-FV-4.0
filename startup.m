%run the vl_feat toolbox first
%addpath('F:/Dropbox/[PENTING TIDAK URGENT]/[ARSIP KULIAH]/Semester 9/#TUGAS_AKHIR/Apps/[GIT]/4.0/vlfeat','-first');
%addpath('F:/Dropbox/[PENTING TIDAK URGENT]/[ARSIP KULIAH]/Semester 9/#TUGAS_AKHIR/Apps/[GIT]/4.0/vlfeat/toolbox','-first');
%windows section
run('F:/Dropbox/[PENTING TIDAK URGENT]/[ARSIP KULIAH]/Semester 9/#TUGAS_AKHIR/Apps/[GIT]/4.0/vlfeat/toolbox/vl_setup');
matPath = uigetdir('C:\Users\yusufazishty-PC\Desktop\[bigfiles]', 'Select .mat files location');
datasetPath = uigetdir('F:\Dropbox\[PENTING TIDAK URGENT]\[ARSIP KULIAH]\Semester 9\#TUGAS_AKHIR\Apps\[GIT]\4.0','Select lfw dataset location');
%linux section
run('/storage-block/4.0/vlfeat/toolbox/vl_setup');
matPath = uigetdir('/storage-block/[bigfiles]', 'Select .mat files location');
datasetPath = uigetdir('/storage-block/4.0','Select lfw dataset location');
%SLAVE-2 linux section
run('/home/yudha/Desktop/vlfeat/toolbox/vl_setup');
matPath = uigetdir('/home/yudha/Desktop/[bigfiles]', 'Select .mat files location');
datasetPath = uigetdir('/home/yudha/Desktop/4.0','Select lfw dataset location');
%all main
main()
%when ready run the main program
