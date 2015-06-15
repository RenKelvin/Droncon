//
//  mySocket.m
//  MJPEGWithSocket
//
//  Created by clover on 14/12/30.
//
//

#import "mySocket.h"
#import "opencv2/highgui/ios.h"
#import "opencv2/opencv.hpp"
#import "vector"


extern "C"
{
    mySocket * adsf;
   // MotionJpegView * _imageView;
    void _jiangboMS()
    {
        if (adsf == nil) {
            adsf = [[mySocket alloc]init];
        }
//        adsf.startSocket;
        [adsf startSocket];
       // MJPEGClient *client;
        //client = [[MJPEGClient alloc] initWithURL:@"http://192.168.8.1:8080/?action=stream" delegate:self timeout:18.0];
//        startSocket;

    }
}

@implementation mySocket

-(void)startSocket{
    if(client == nil)
    {
        client = [[MJPEGClient alloc] initWithURL:@"http://192.168.8.1:8080/?action=stream" delegate:self timeout:18.0];
        client.userName = @"admin";
        client.password = @"";
        [client start];
    }
}



- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}


- (void) mjpegClient:(MJPEGClient*) client didReceiveImage:(UIImage*) image
{
    cv::Mat frame;
    
    cv::Mat gray;
    cv::Mat Thresholdresult;
    cv::Mat Thresholdresult_copy;
    UIImage *imageResult;
    
    [imgView setImage:image];
    
    int64 tick = cv::getTickCount();
    //[theLock lock];
    //UIImage* image = [self.NSImageArry[0] copy];
    //[self.NSImageArry removeObjectAtIndex:0];
    //[theLock unlock];
    frame = [self cvMatFromUIImage:image];
    cv::cvtColor(frame, gray, CV_BGR2GRAY);
    // 反色
    cv::bitwise_not(gray, gray);
    cv::adaptiveThreshold(gray, Thresholdresult, 255, CV_ADAPTIVE_THRESH_MEAN_C, CV_THRESH_BINARY, 15, 13);
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    Thresholdresult_copy = Thresholdresult.clone();
    cv::findContours(Thresholdresult, contours, hierarchy, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
    UIImage * resultImage2 = MatToUIImage(Thresholdresult_copy);
    //self.imageResult = resultImage2;
    imageResult = resultImage2;
    //  getimageresult = YES;
    tick = cv::getTickCount()-tick;
    
    [imgViewB setImage:imageResult];
}

- (void) mjpegClient:(MJPEGClient*) client didReceiveError:(NSError*) error
{
    NSLog(@"Error! %@", [error localizedDescription]);
}

- (void)dealloc
{
    //   [_window release];
    //   [imgView release];
    //   [imgViewB release];
    //   [super dealloc];
}

@end
