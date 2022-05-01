clc
%% ͼ��ƽ������ȥ������
% ���̣����ɻҶ�ͼ�������˲�����Ӧ���˲���ִ���˲�������PS����ֵ�˲����̲�һ����
% ��ȡͼ��
A = imread('img.jpg');
 
% ת��Ϊ�Ҷ�ͼ��
A = rgb2gray(A);
 
% ��ֵ�˲�
average_h = fspecial('average', [9 9]);
 
% ��˹�˲�
gaussian_h = fspecial('gaussian', [13 13]);
 
% ��ֵ�˲�����ͼ��
B_average = imfilter(A, average_h);
 
% ��˹�˲�����ͼ��
B_gaussian = imfilter(A, gaussian_h);
 
% ��ֵ�˲�����ͼ��
B_median = medfilt2(A, [5 5]);

% �����˲�����ͼ��
A_guided_filtered = imguidedfilter(A);
 
% ���չʾ
figure, subplot(2, 3, 1), imshow(A), title('Original input image');
subplot(2, 3, 2), imshow(B_average), title('Image filtered using Averaging filter');
subplot(2, 3, 3), imshow(B_gaussian), title('Image filtered using Gaussian filter');
subplot(2, 3, 4), imshow(B_median), title('Image filtered using Median filter');
subplot(2, 3, 5), imshow(A_guided_filtered), title('Image filtered using Guided filter');