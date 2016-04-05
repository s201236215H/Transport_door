close all;clear
oim = imread('stair3.jpg'); % keep original for display
oheight = size(oim,1); % get height of img
ratio = 450/oheight;
oim = imresize(oim,ratio);
imwrite(imresize(oim,0.3),'../../../../../Desktop/oim.bmp');
im = oim;
if(min(size(im))==3)
    im = rgb2gray(im);
end
 if exist('imgaussfilt','file')==2,
     gim = imgaussfilt(im,0.8);
 else
     gim = imgaussianfilt(im,3,0.1);
 end
gim = histeq(gim); % for stair2
imwrite(imresize(gim,0.3),'../../../../../Desktop/gim.bmp');
[BW,threhold] = edge(gim,'log',0.0035); %original 0.0035
BW = imfilter(1*BW,[1,1,1;1,1,1;-2,-2,-2]); % for stair3
imshow(BW);
imwrite(imresize(1*BW,0.3),'../../../../../Desktop/BW.bmp');
[H,T,R] = hough(BW,'RhoResolution',0.7,'ThetaResolution',0.6);
P = houghpeaks(H,20,'threshold',ceil(0.1*max(H(:))));
lines = houghlines(BW,T,R,P,'FillGap',2,'MinLength',40);
figureHandle=figure;imshow(oim), hold on
max_len = 0;
counter = 0;
temp = -1; 
gap_len = ones([1 length(lines)-1]); j = 1;
pixel = ones([1 length(lines)]);
lineFields = fieldnames(lines);
linesCell = struct2cell(lines);
sz = size(linesCell);
linesCell = reshape(linesCell,sz(1),[]);
linesCell = linesCell';
linesCell = sortrows(linesCell,4);
linesCell = reshape(linesCell',sz);
lines = cell2struct(linesCell,lineFields,1);
for k=1:length(lines)    
    if abs(lines(k).theta) ~= 90
       continue;    
    elseif ~isstruct(temp) || lines(k).rho ~= temp.rho
        counter=counter+1;
        
    end   
    temp = lines(k);
end

for k=1:length(lines)
    figure(figureHandle);hold on;
    if(lines(k).theta ==-90 )
        xy = [lines(k).point1; lines(k).point2];
        xy1 = [lines(k).point1+15; lines(k).point2+15];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        %plot(xy1(:,1),xy1(:,2),'LineWidth',0.5,'Color','red');
    end

end
saveas(gcf,'../../../../../Desktop/result.jpg');

    

disp(counter);

