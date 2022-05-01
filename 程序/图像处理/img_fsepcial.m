clc
%% 图像降噪
% 读取图片
A = imread('img.jpg');
 
% 生成高斯和均值滤波
h_gaussian = fspecial('gaussian');
h_average = fspecial('average');
 
% 高斯和均值滤波进行图像处理
B_gaussian = imfilter(A, h_gaussian);
B_average = imfilter(A, h_average);
 
% 中值滤波
A_gray = rgb2gray(A);
B_median = medfilt2(A_gray);
 
% 结果展示
figure, subplot(2, 2, 1), imshow(A), title('Original image with Salt & Pepper noise');
subplot(2, 2, 2), imshow(B_gaussian), title('Input image filtered using Gaussian filter');
subplot(2, 2, 3), imshow(B_average), title('Input image filtered using Average filter');
subplot(2, 2, 4), imshow(B_median), title('Input image filtered using Median filter');