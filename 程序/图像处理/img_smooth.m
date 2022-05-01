clc
%% 图像平滑化（去噪声）
% 流程：生成灰度图像，生成滤波器，应用滤波，执行滤波操作，PS：中值滤波过程不一样。
% 读取图像
A = imread('img.jpg');
 
% 转化为灰度图像
A = rgb2gray(A);
 
% 均值滤波
average_h = fspecial('average', [9 9]);
 
% 高斯滤波
gaussian_h = fspecial('gaussian', [13 13]);
 
% 均值滤波处理图像
B_average = imfilter(A, average_h);
 
% 高斯滤波处理图像
B_gaussian = imfilter(A, gaussian_h);
 
% 中值滤波处理图像
B_median = medfilt2(A, [5 5]);

% 导向滤波处理图像
A_guided_filtered = imguidedfilter(A);
 
% 结果展示
figure, subplot(2, 3, 1), imshow(A), title('Original input image');
subplot(2, 3, 2), imshow(B_average), title('Image filtered using Averaging filter');
subplot(2, 3, 3), imshow(B_gaussian), title('Image filtered using Gaussian filter');
subplot(2, 3, 4), imshow(B_median), title('Image filtered using Median filter');
subplot(2, 3, 5), imshow(A_guided_filtered), title('Image filtered using Guided filter');