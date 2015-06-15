//
//  mySocket.h
//  MJPEGWithSocket
//
//  Created by clover on 14/12/30.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJPEGClient.h"

@interface mySocket : NSObject
{
    MJPEGClient *client;
    UIImageView *imgView;
    UIImageView *imgViewB;
}
-(void)startSocket;

@end
