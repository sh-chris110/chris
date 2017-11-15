#!/usr/bin/python
import cv2
import Image
import numpy as np

print cv2.__version__

img_color = cv2.imread("1.jpg")

cv2.imshow("1", img_color)
k=cv2.waitKey(0)
cv2.destroyAllWindows();

img_gray = cv2.cvtColor(img_color,cv2.COLOR_RGB2GRAY) 
cv2.imshow("2", img_gray)
K=cv2.waitKey(0)
cv2.destroyAllWindows();

img_blured = cv2.GaussianBlur(img_gray,(15,15), 0)
cv2.imshow("3", img_blured)
K=cv2.waitKey(0)
cv2.destroyAllWindows();

#(T, thresh) = cv2.threshold(img_blured, 170, 255, cv2.THRESH_BINARY)
#thresh = cv2.adaptiveThreshold(img_blured, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY_INV, 11, 4)

thresh = cv2.adaptiveThreshold(img_blured, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV, 15, 3)
cv2.imshow("4", thresh)
K=cv2.waitKey(0)
cv2.destroyAllWindows();

dilate = cv2.dilate(thresh, None, iterations=3)
cv2.imshow("5", dilate)
K=cv2.waitKey(0)
cv2.destroyAllWindows();


o_img, contours, hierarchy = cv2.findContours(dilate, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)  
cv2.imshow("6", o_img)
K=cv2.waitKey(0)
cv2.destroyAllWindows();
cnt = 2
for contour in contours:
    x, y, w, h = cv2.boundingRect(contour)
    cv2.rectangle(img_gray, (x, y), (x+w, y+h), (0, 255, 0), 2)
    img_roi = img_color[y:y+h, x:x+w];
    img = Image.fromarray(img_roi,"RGB");
    img.save("%d.jpg"%(cnt));
    cnt += 1;
    cv2.imshow("8", img_roi)
    K=cv2.waitKey(0)
    cv2.destroyAllWindows();

    #rect = cv2.minAreaRect(contour)
    #box = cv2.boxPoints(rect)
    #box = np.int0(box)
    #cv2.drawContours(img_color,[box],0,(0,0,255),4)

    #rows,cols = img.shape
    #M = cv2.getRotationMatrix2D((cols/2,rows/2),90,1)
    #dst = cv2.warpAffine(img,M,(cols,rows))

cv2.imshow("7", img_color)
K=cv2.waitKey(0)
cv2.destroyAllWindows();
