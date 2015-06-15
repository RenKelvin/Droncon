//
//  MJPEGWithSocketAppDelegate.h
//  MJPEGWithSocket
//
//  Created by Hao Hu on 29.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPEGClient.h"

@interface MJPEGWithSocketAppDelegate : NSObject <UIApplicationDelegate,MJPEGClientDelegate> {
    
    IBOutlet UIImageView *imgView;
    IBOutlet UIImageView *imgViewB;
    MJPEGClient *client;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction) sendClicked;//start
- (IBAction) stopClicked;//stop
- (IBAction) btnReleaseClicked;//release
- (IBAction) btnCreateClicked;//create

@end
