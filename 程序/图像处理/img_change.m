clc
%% ͼ����̬ѧ
% Erosion ��ʴ ��imerode �����������壬ȥë�̣��������С��
% Dilation ���� imdilate��ƴ�����壬�����С�ӣ�������
% �����㣺�ȸ�ʴ�����ͣ��������塢ȥë�̡�ȥС�㣨����㣩��ȥС����������ӱ�С��
% �����㣺�������ٸ�ʴ������ӱ���ڲ���������ʧ������ӱ��ë�̲��䡣
% ��ȡͼƬ
A = imread('img.jpg');
 
% ת��Ϊ�Ҷ�ͼ��
A = rgb2gray(A);
 
% ���ɽṹԪ��
se = strel('disk', 15);
 
% ��ʴ
B_eroded = imerode(A, se);
 
% ����
B_dilated = imdilate(A, se);
 
% ������
B_open = imopen(A, se);
 
% ������
B_close = imclose(A, se);

% ���չʾ
figure, subplot(2, 3, 1), imshow(A), title('Original read image');
subplot(2, 3, 2), imshow(B_eroded), title('Original image after Erosion');
subplot(2, 3, 3), imshow(B_dilated), title('Original image after Dilation');
subplot(2, 3, 4), imshow(B_open), title('Original image after Opening');
subplot(2, 3, 5), imshow(B_close), title('Original image after Closing');

%% �������͵õ������Ե
% Read an input image
A = imread('img.jpg');
 
% Convert the read image to single channel image
A = rgb2gray(A);
 
% Generate structuring element for use
se = strel('disk', 5);
 
% Perform image dilation
% To get the object boundary, subtract the original image from the dilated
% version of the orginal image
B_dilated = imdilate(A, se);
 
% Subtract the original image from dilated image
B_boundary = B_dilated - A;
 
% Display images side by side
figure, subplot(1, 3, 1), imshow(A), title('Original image');
subplot(1, 3, 2), imshow(B_dilated), title('Original image after Dilation');
subplot(1, 3, 3), imshow(B_boundary), title('Original image with highlighted binary object boundaries');

%% ���ø�ʴ�õ������Ե
% Read an input image
A = imread('img.jpg');
 
% Convert the read image to single channel image
A = rgb2gray(A);
 
% Generate structuring element for use
se = strel('disk', 5);
 
% Perform image erosion
B_eroded = imerode(A, se);
 
% Subtract the eroded image from original image
B_boundary = A - B_eroded;
 
% Display images side by side
figure, subplot(1, 3, 1), imshow(A), title('Original image');
subplot(1, 3, 2), imshow(B_eroded), title('Original image after Erosion');
subplot(1, 3, 3), imshow(B_boundary), title('Original image with highlighted binary object boundaries');