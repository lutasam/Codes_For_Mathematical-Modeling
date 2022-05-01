clc
%% ͼ����
% ��ȡͼƬ
A = imread('img.jpg');
 
% ���ɸ�˹�;�ֵ�˲�
h_gaussian = fspecial('gaussian');
h_average = fspecial('average');
 
% ��˹�;�ֵ�˲�����ͼ����
B_gaussian = imfilter(A, h_gaussian);
B_average = imfilter(A, h_average);
 
% ��ֵ�˲�
A_gray = rgb2gray(A);
B_median = medfilt2(A_gray);
 
% ���չʾ
figure, subplot(2, 2, 1), imshow(A), title('Original image with Salt & Pepper noise');
subplot(2, 2, 2), imshow(B_gaussian), title('Input image filtered using Gaussian filter');
subplot(2, 2, 3), imshow(B_average), title('Input image filtered using Average filter');
subplot(2, 2, 4), imshow(B_median), title('Input image filtered using Median filter');