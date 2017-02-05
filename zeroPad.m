function [numb_pad] =  zeroPad(numb, len_numb)
    for i=1:len_numb
        numb = strcat('0',numb);
    end
    numb_pad = numb;
end