//g++ ocr.cpp -lopencv_core -lopencv_ml
#include <stdio.h>
#include <stdlib.h>

// for non-fiexed arguments
#include <stdarg.h>

// for openCV3.2
#include "opencv2/core.hpp"
#include "opencv2/ml.hpp"
//-lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_legacy -lopencv_ml -lpthread

inline void output (int level, const char *output, va_list args) {
    printf(output, args);
    return;
}

inline void debug (const char *info, ...) {
    va_list ap;
    va_start(ap, info);
    output(1, info, ap); 
    va_end(ap);
    return;
}

inline void warning (const char *info, ...) {
    va_list ap;
    va_start(ap, info);
    output(1, info, ap); 
    va_end(ap);
    return;
}

inline void info (const char *info, ...) {
    va_list ap;
    va_start(ap, info);
    output(1, info, ap); 
    va_end(ap);
    return;
}

inline void error (const char *info, ...) {
    va_list ap;
    va_start(ap, info);
    output(1, info, ap); 
    va_end(ap);
    return;
}

using namespace cv;
using namespace std;

int main (int argc, char * argv[])
{
    info ("start opencv programmer\n");
    Mat a;

    //Ptr<ml::KNearest> knn;
    Ptr<ml::KNearest> knn = ml::KNearest::create();
    knn.save("./knn2.xml");
    return 0;
}

