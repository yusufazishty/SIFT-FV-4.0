function imageProcessed = preprocess(image)
    imageBw = rgb2gray(image);
    faceDetector = vision.CascadeObjectDetector();
    boxRoi = step(faceDetector, imageBw);
    if size(boxRoi,1)>1 %more than one face detected
        [val, pos] = sort(boxRoi(:,4),'descend');
        boxRoi = boxRoi(pos(1),:);
        disp(boxRoi);
    else if size(boxRoi,1)==0 %no face detected, not front facing face
        start = round(size(imageBw)/4);
        big = start+start;
        boxRoi=[start,big];
        end
    end
    imageProcessed = imcrop(image, boxRoi);
    %imageProcessed = imresize(imageProcessed,[160,160]);
    imageProcessed = imresize(imageProcessed,[160,125]);
end
%imshow(imageProcessed);
%hold on;
%start=[25,25];
%big=[100,135]; % will be added to the corner, beaceuse it's the size, not
%xmax ymax
%the one in the bounds of vl_dsift is actualy xmax ymax
%rectangle('Position',[start,ended],'LineWidth', 0.5, 'Linestyle', '-', 'EdgeColor', 'r')
