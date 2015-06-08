

#import "MyVideoBuffer.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CFNetwork/CFNetwork.h>
#import <CFNetwork/CFSocketStream.h>
#import <CFNetwork/CFFTPStream.h>
#import <CFNetwork/CFHost.h>
#import <CFNetwork/CFHTTPMessage.h>
#import <CFNetwork/CFHTTPStream.h>
#import <CFNetwork/CFNetDiagnostics.h>
#import <CFNetwork/CFNetServices.h>
#import <CFNetwork/CFNetworkDefs.h>
#import <CFNetwork/CFNetworkErrors.h>
#import <CFNetwork/CFProxySupport.h>

#include "System.h"
#include "teapot.h"

#include <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>



System ptam;


@implementation MyVideoBuffer

@synthesize _session;
@synthesize previousTimestamp;
@synthesize videoFrameRate;
@synthesize videoDimensions;
@synthesize videoType;
@synthesize CameraTexture=m_textureHandle;

EAGLContext *acontext;
GLuint arb,afb;
GLint abw;
GLint abh;

// SOCKET
int server_socket=0;
char data[1024];

- (IBAction) pressButton {
	NSLog(@"Pressed screen");
		ptam.SendTrackerStartSig();
}

-(id) init
{
	if ((self = [super init]))
	{
		NSError * error;
		
		//-- Setup our Capture Session.
		self._session = [[AVCaptureSession alloc] init];
		
		[self._session beginConfiguration];
		
		//-- Set a preset session size. 
//		[self._session setSessionPreset:AVCaptureSessionPreset640x480];
        self._session.sessionPreset = AVCaptureSessionPreset640x480;
       // [self._session s]
    //    [self._session ]
        
      //  if ( [self._session lockForConfiguration:&error] ) {
          //  [self._session setActiveFormat:newFormat];
        //    [self._session setActiveVideoMinFrameDuration:CMTimeMake(1, 60)];
        //    [self._session setActiveVideoMaxFrameDuration:CMTimeMake(1, 60)];
        //    [self._session unlockForConfiguration];
       // }
        
        //[self._session setSessionPreset:AVCaptureSessionPresetHigh];
        
		
		//-- Creata a video device and input from that Device.  Add the input to the capture session.
		AVCaptureDevice * videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		if(videoDevice == nil)
			return nil;
		
		//-- Add the device to the session.
		AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if(error)
			return nil;
		//[self._session set = 60.0];
        
		[self._session addInput:input];
		
		//-- Create the output for the capture session.  We want 32bit BRGA
		AVCaptureVideoDataOutput * dataOutput = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
		[dataOutput setAlwaysDiscardsLateVideoFrames:YES]; // Probably want to set this to NO when we're recording//
		[dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]]; // Necessary for manual preview
		
		// we want our dispatch to be on the main thread so OpenGL can do things with the data
		[dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        
        dataOutput.minFrameDuration = CMTimeMake(1, 60);    // 设置帧率
        
		
		
		[self._session addOutput:dataOutput];
		[self._session commitConfiguration];
		
		//-- Pre create our texture, instead of inside of CaptureOutput.
		m_textureHandle = [self createVideoTextuerUsingWidth:640 Height:480];
		
		//and create output Black and White image
		bwImage = (unsigned char *)malloc(640*480*4);
		memset(bwImage,0,640*480*4);
	}
    
    //[self doConnect];
    
    
//    struct sockaddr_in server_addr;
//    server_addr.sin_len = sizeof(struct sockaddr_in);
//    server_addr.sin_family = AF_INET;
//    server_addr.sin_port = htons(11378);
//    server_addr.sin_addr.s_addr = inet_addr("192.168.1.7");
//    bzero(&(server_addr.sin_zero),8);
//    
//    server_socket = socket(AF_INET, SOCK_STREAM, 0);
//    if (server_socket == -1) {
//        perror("socket error");
//    }
//    if (connect(server_socket, (struct sockaddr *)&server_addr, sizeof(struct sockaddr_in))==0)std::cout<<server_socket<<std::endl;
    
	return self;
}

-(GLuint)createVideoTextuerUsingWidth:(GLuint)w Height:(GLuint)h
{
	//	int dataSize = w * h ;
	//	uint8_t* textureData = (uint8_t*)malloc(dataSize);
	//	if(textureData == NULL)
	//		return 0;
	//	memset(textureData, 128, dataSize);
	
	GLuint handle;
	glGenTextures(1, &handle);
	glBindTexture(GL_TEXTURE_2D, handle);
	glTexParameterf(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_FALSE);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, w, h, 0, GL_LUMINANCE, 
				 GL_UNSIGNED_BYTE, NULL);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glBindTexture(GL_TEXTURE_2D, 0);
	//free(textureData);
	
	return handle;
}

- (void) resetWithSize:(GLuint)w Height:(GLuint)h
{
	NSLog(@"_session beginConfiguration");
	[_session beginConfiguration];
	
	//-- Match the wxh with a preset.
	if(w == 1280 && h == 720)
	{
		[_session setSessionPreset:AVCaptureSessionPreset1280x720];
	}
	else if(w == 640)
	{
		[_session setSessionPreset:AVCaptureSessionPreset640x480];
	}
	else if(w == 480)
	{
		[_session setSessionPreset:AVCaptureSessionPresetMedium];
	}
	else if(w == 192)
	{
		[_session setSessionPreset:AVCaptureSessionPresetLow];
	}
	
	[_session commitConfiguration];
	NSLog(@"_session commitConfiguration");
}

- (void) convertToBlackWhite:(unsigned char *) pixels 
{
	memcpy(bwImage,pixels,640*480*4);
	//changing the order of access of the individual pixels massively changes the speed of the program.
	//i think this is because there are multiple and frequent cache misses when the pixels are not called in order
	unsigned int * pntrBWImage= (unsigned int *)bwImage;
	unsigned int index=0;
	unsigned int fourBytes;
	for (int j=0;j<480; j++)
	{
		for (int i=0; i<640; i++) 
		{
			index=(640)*j+i;
			fourBytes=pntrBWImage[index];
			bwImage[index]=((unsigned char)fourBytes>>(2*8)) +((unsigned char)fourBytes>>(1*8))+((unsigned char)fourBytes>>(0*8));
		}
	}
}

- (void) renderTeapot:(std::vector<float>)rt
{	   
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	//glTranslatef(rt[0], rt[1], rt[2]);
	glTranslatef(0, 0, -400);
	glScalef(400, 400, 400);
	glRotatef(rt[3], rt[4], rt[5], rt[6]);
	
//	glScalef(1, 1, -1);
	glColor4f(1,0,1,1);
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(3, GL_FLOAT, 0, teapot_vertices);
	
	// Draw teapot. The new_teapot_indicies array is an RLE (run-length encoded) version of the teapot_indices array in teapot.h
	for(int i = 0; i < num_teapot_indices; i += new_teapot_indicies[i] + 1)
	{
		glDrawElements(GL_TRIANGLE_STRIP, new_teapot_indicies[i], GL_UNSIGNED_SHORT, &new_teapot_indicies[i+1]);
	}
	
	glDisableClientState(GL_VERTEX_ARRAY);
}




CVD::Image<CVD::byte> mimFrameBW;

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
	CMTime timestamp = CMSampleBufferGetPresentationTimeStamp( sampleBuffer );
	if (CMTIME_IS_VALID( self.previousTimestamp ))
        self.videoFrameRate = (1.0 / CMTimeGetSeconds( CMTimeSubtract( timestamp, self.previousTimestamp ) )) * 2  ;
        //self.videoFrameRate = 60.0;
        //self.videoFrameRate = 1.0 / CMTimeGetSeconds( CMTimeSubtract( timestamp, self.previousTimestamp ) );
	
	previousTimestamp = timestamp;
	
	CMFormatDescriptionRef formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer);
	self.videoDimensions = CMVideoFormatDescriptionGetDimensions(formatDesc);
	
	CMVideoCodecType type = CMFormatDescriptionGetMediaSubType(formatDesc);
#if defined(__LITTLE_ENDIAN__)
	type = OSSwapInt32(type);
#endif
	self.videoType = type;
	
	CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
	
	// This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
	[EAGLContext setCurrentContext:acontext];
	
    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, afb);
    glViewport(0, 0, abw, abh);
	
	glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
	
	
	unsigned char* linebase = (unsigned char *)CVPixelBufferGetBaseAddress( pixelBuffer );
	[self convertToBlackWhite:linebase];
	
	static int SKIP=1;
	static int skippedFrames=0;
	
	if (0) {
		glBindTexture(GL_TEXTURE_2D, m_textureHandle);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, videoDimensions.width, videoDimensions.height, GL_LUMINANCE, GL_UNSIGNED_BYTE, bwImage);
		[self renderCameraToSprite:m_textureHandle];
	}
	else
		if (skippedFrames++%SKIP==0){
			ptam.RunOneFrame(bwImage,m_textureHandle);
            

			//[self renderTeapot:ptam.getCurrentPose()];
			//[self renderTeapot:pos];
			// This application only creates a single color renderbuffer which is already bound at this point.
			// This call is redundant, but needed if dealing with multiple renderbuffers.
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, arb);
			
			[acontext presentRenderbuffer:GL_RENDERBUFFER_OES];
			
		}
# if 0
    // 初始化socket
    if(server_socket==0)
    {
        struct sockaddr_in server_addr;
        server_addr.sin_len = sizeof(struct sockaddr_in);
        server_addr.sin_family = AF_INET;
        server_addr.sin_port = htons(11378);
        server_addr.sin_addr.s_addr = inet_addr("192.168.199.184"); // 172.20.10.4 192.168.1.7
        bzero(&(server_addr.sin_zero),8);
        
        server_socket = socket(AF_INET, SOCK_STREAM, 0);
        if (server_socket == -1) {
            perror("socket error");
        }
        if (connect(server_socket, (struct sockaddr *)&server_addr, sizeof(struct sockaddr_in))==0)std::cout<<server_socket<<std::endl;
    }
    // 通过socket发送数据
    else
    {
        
        for(int i=0;i<1024;i++)data[i]='\0';
        
        std::stringstream ss;
        std::string sss,sss1,sss2,sss3,sss4,sss5,sss6,sss7,sss8,sss9,sss10,sss11,sss12,sss13,sss14,sss15,sss16;
        ss<<ptam.getCurrentPoseInverse()[0];
        ss<<" ";
        ss>>sss1;sss1+=";";
        ss<<ptam.getCurrentPoseInverse()[1];
        ss<<" ";
        ss>>sss2;sss2+=";";
        ss<<ptam.getCurrentPoseInverse()[2];
        ss<<" ";
        ss>>sss3;sss3+=";";
        ss<<ptam.getCurrentPoseInverse()[3];
        ss<<" ";
        ss>>sss4;sss4+=";";
        ss<<ptam.getCurrentPoseInverse()[4];
        ss<<" ";
        ss>>sss5;sss5+=";";
        ss<<ptam.getCurrentPoseInverse()[5];
        ss<<" ";
        ss>>sss6;sss6+=";";
        ss<<ptam.getCurrentPoseInverse()[6];
        ss<<" ";
        ss>>sss7;sss7+=";";
        
        ss<<ptam.getCurrentPoseInverse()[7];
        ss<<" ";
        ss>>sss8;sss8+=";";
        ss<<ptam.getCurrentPoseInverse()[8];
        ss<<" ";
        ss>>sss9;sss9+=";";
        ss<<ptam.getCurrentPoseInverse()[9];
        ss<<" ";
        ss>>sss10;sss10+=";";
        ss<<ptam.getCurrentPoseInverse()[10];
        ss<<" ";
        ss>>sss11;sss11+=";";
        ss<<ptam.getCurrentPoseInverse()[11];
        ss<<" ";
        ss>>sss12;sss12+=";";
        ss<<ptam.getCurrentPoseInverse()[12];
        ss<<" ";
        ss>>sss13;sss13+=";";
        ss<<ptam.getCurrentPoseInverse()[13];
        ss<<" ";
        ss>>sss14;sss14+=";";
        ss<<ptam.getCurrentPoseInverse()[14];
        ss<<" ";
        ss>>sss15;sss15+=";";
        ss<<ptam.getCurrentPoseInverse()[15];
        ss<<" ";
        ss>>sss16;//sss16+=";";
        
        
        sss=sss1+sss2+sss3+sss4+sss5+sss6+sss7+sss8+sss9+sss10+sss11+sss12+sss13+sss14+sss15+sss16;
       
        for(int i=0;i<sss.length();i++)data[i]=sss.c_str()[i];
        
        std::cout<<"output : "<<sss16<<std::endl;
        
        // 发送数据
        if(send(server_socket, data, strlen(data), 0)==-1)perror("send error");
        

        
    }
    
# endif
    
	
	CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
	
}



-(void)renderCameraToSprite:(uint)text
{
	GLfloat spriteTexcoords[] = {
		1,1,   
		1,0.0f,
		0,1,   
		0.0f,0,};
	
	GLfloat spriteVertices[] =  {
		0,0,0,   
		640,0,0,   
		0,480,0, 
		640,480,0};
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0, 640, 0, 480, 0, 1);
	
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
	
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	glVertexPointer(3, GL_FLOAT, 0, spriteVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, spriteTexcoords);	
	glBindTexture(GL_TEXTURE_2D, text);
	
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glBindTexture(GL_TEXTURE_2D, 0);
	
}

- (void)render
{
    // Replace the implementation of this method to do your own custom drawing
	
}


- (void) setGLStuff:(EAGLContext*)c :(GLuint)rb :(GLuint)fb :(GLuint)bw :(GLuint)bh 
{
	acontext=c;
	arb=rb;
	afb=fb;
	abw=bw;
	abh=bh;
}

- (void)dealloc 
{
	[_session release];
	
	[super dealloc];
	free(bwImage);
}

@end
