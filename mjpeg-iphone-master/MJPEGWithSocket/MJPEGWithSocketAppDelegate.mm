//
//  MJPEGWithSocketAppDelegate.m
//  MJPEGWithSocket
//
//  Created by Hao Hu on 29.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MJPEGWithSocketAppDelegate.h"
#import "opencv2/highgui/ios.h"
#import "opencv2/opencv.hpp"
#import "vector"


@implementation MJPEGWithSocketAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (IBAction) sendClicked
{
    [client start];
}

- (IBAction) stopClicked
{
    [client stop];
}

- (IBAction) btnReleaseClicked
{
    if (client.isStopped)
    {
        //   [client release];
        client = nil;
    }
    else
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Please stop first!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [view show];
        //  [view release];
        view = nil;
    }
}

- (IBAction) btnCreateClicked
{
    if (client == nil)
    {
        //client = [[MJPEGClient alloc] initWithURL:@"http://99.238.87.20:81/MJPEG.CGI" delegate:self timeout:18.0];
        client = [[MJPEGClient alloc] initWithURL:@"http://192.168.8.1:8080/?action=stream" delegate:self timeout:18.0];
        
        client.userName = @"admin";
        client.password = @"";
        [client start];
    }
}

//cv::Mat frame ;
//cv::Mat gray;
//cv::Mat Thresholdresult;
//cv::Mat Thresholdresult_copy;


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
    // UIImage *imageResult;
    
    [imgView setImage:image];
    
    //    int64 tick = cv::getTickCount();
    //    //[theLock lock];
    //    //UIImage* image = [self.NSImageArry[0] copy];
    //    //[self.NSImageArry removeObjectAtIndex:0];
    //    //[theLock unlock];
    //    frame = [self cvMatFromUIImage:image];
    //    cv::cvtColor(frame, gray, CV_BGR2GRAY);
    //
    ////    int mypix = 0;
    ////    for(int i = 0;i<10;i++)
    ////    {
    ////        for (int x = 0;x<640;x++)
    ////        {
    ////            for (int y = 0;y<480;y++)
    ////            {
    ////                mypix = gray.at<unichar>(y,x);
    ////            }
    ////        }
    ////    }
    //    // 反色
    //    cv::bitwise_not(gray, gray);
    //    cv::adaptiveThreshold(gray, Thresholdresult, 255, CV_ADAPTIVE_THRESH_MEAN_C, CV_THRESH_BINARY, 15, 13);
    //    std::vector<std::vector<cv::Point> > contours;
    //    std::vector<cv::Vec4i> hierarchy;
    //    Thresholdresult_copy = Thresholdresult.clone();
    //    cv::findContours(Thresholdresult, contours, hierarchy, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
    //    UIImage * resultImage2 = MatToUIImage(Thresholdresult_copy);
    //    //self.imageResult = resultImage2;
    //    imageResult = resultImage2;
    //    //getimageresult = YES;
    //    tick = cv::getTickCount()-tick;
    //
    //    [imgViewB setImage:imageResult];
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
