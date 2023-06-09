import cv2 as cv
import numpy as np

x = cv.imread("pixie.png")
print(x.shape)
cv.imwrite("TEXT_CIRC_WON_MSG_0.png",x[:32,:32,:])
cv.imwrite("TEXT_CIRC_WON_MSG_1.png",x[:32,32:64,:])
cv.imwrite("TEXT_CIRC_WON_MSG_2.png",x[:32,32*2:32*3,:])
cv.imwrite("TEXT_CIRC_WON_MSG_3.png",x[:32,32*3:32*4,:])
cv.imwrite("TEXT_CIRC_WON_MSG_4.png",x[:32,32*4:32*5,:])
cv.imwrite("TEXT_CIRC_WON_MSG_5.png",x[:32,32*5:32*6,:])
cv.imwrite("TEXT_CIRC_WON_MSG_6.png",x[:32,32*6:32*7,:])
cv.imwrite("TEXT_CIRC_WON_MSG_7.png",x[:32,32*7:32*8,:])
cv.imwrite("TEXT_CIRC_WON_MSG_8.png",x[:32,32*8:32*9,:])


# x0 = cv.imread("sss1.png")
# x1 = cv.imread("sss2.png")
# x2 = cv.imread("sss3.png")
# x3 = cv.imread("sss4.png")
# x4 = cv.imread("sss5.png")

# cv.imwrite("TEXT_CIRC_RECENT_POS_0.png", np.dstack((x0[:,:,1],x0[:,:,2],x0[:,:,2])))
# cv.imwrite("TEXT_CIRC_RECENT_POS_1.png", np.dstack((x1[:,:,1],x1[:,:,2],x1[:,:,2])))
# cv.imwrite("TEXT_CIRC_RECENT_POS_2.png", np.dstack((x2[:,:,1],x2[:,:,2],x2[:,:,2])))
# cv.imwrite("TEXT_CIRC_RECENT_POS_3.png", np.dstack((x3[:,:,1],x3[:,:,2],x3[:,:,2])))
# cv.imwrite("TEXT_CIRC_RECENT_POS_4.png", np.dstack((x4[:,:,1],x4[:,:,2],x4[:,:,2])))
