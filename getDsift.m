function [dess] = getDsift(image, jenis)
    I = rgb2gray(image); % 32 bit float, grayscale, 160*125
    power = [1:5];
    sigmas = 1.6*(2.^(0.5.*power));
    dess={};
    for i=1:length(sigmas)
        height = size(I,1); width = size(I,2);
        blockSize=6;
        Is = vl_imsmooth(single(I), sigmas(i));
        bound = [25,25,100,135];
        %dense sift, faster sift
        [kp, des]=vl_dsift(Is, 'Size', blockSize, 'Step', 1, 'Bounds', bound);
        %root sift == normalized sift
        for j=1:size(des,2)
            vector = des(:,j);
            vector = single(vector)/norm(single(vector));
            vector = vector.^0.5;
            des(:,j)=vector;
        end
        %pca the dimension 128 to 64
        des=pca(single(des),'NumComponents',64);
        if jenis==1 %menggunakan informasi lokasi
            x=kp(1,:); y=kp(2,:); x=(x/width)-0.5; y=(y/height)-0.5;
            x=x'; y=y';
            des=horzcat(des,x); des=horzcat(des,y);
        end
        dess=vertcat(dess,des); 
        %dess=cell2mat(dess);
    end  
end