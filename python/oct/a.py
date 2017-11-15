#!/usr/bin/python
import cv2
import Image
import numpy as np
from skimage.feature import hog
#hog(image, orientations=9, pixels_per_cell=(8, 8), cells_per_block=(3, 3), block_norm='L1', visualise=False, transform_sqrt=False, feature_vector=True, normalise=None)

img_color = cv2.imread("22.jpg")
#img_color = cv2.imread("3.jpg")
#img_color = cv2.imread("20.jpg")
#img_color = cv2.imread("3.jpg")
#img_color = cv2.imread("5.jpg")
img_gray = cv2.cvtColor(img_color,cv2.COLOR_RGB2GRAY)
img_blured = cv2.GaussianBlur(img_gray,(15,15), 0)

#im_digit = cv2.threshold(img_gray, 210, 255, cv2.THRESH_BINARY)
#im_digit = (255-im_digit)
#thresh = cv2.adaptiveThreshold(img_blured, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV, 15, 3)

T, thresh = cv2.threshold(img_gray, 121, 255, cv2.THRESH_BINARY)
thresh = (255-thresh)
w, h = thresh.shape
dm = max(w, h)

target = np.full([dm,dm], 0, dtype=thresh.dtype)
target[0:w, 0:h] = thresh

cv2.imshow("4", target)
K=cv2.waitKey(0)
cv2.destroyAllWindows();

print img_blured.shape
b = hog(target, orientations=36, pixels_per_cell=(10,10), cells_per_block=(1, 1), block_norm='L2-Hys', visualise=False, transform_sqrt=False, feature_vector=True, normalise=None)
print b
