// Copyright 2008 Isis Innovation Limited
#include "System.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#include <stdlib.h>
#include <vector>

#import "GLVideoFrameAppDelegate.h"

#include "ATANCamera.h"
#include "MapMaker.h"
#include "Tracker.h"

using namespace CVD;
using namespace std;

vector<float> System::getCurrentPose()
{
  	SE3<> se3pose=mpTracker->GetCurrentPose();
    
    
    SE3<> nse=se3pose.inverse();
    nse.get_translation();
    
	vector<float> pose(7);
	Vector<3> translation,rotation;
	
	translation=se3pose.get_translation();
	rotation=se3pose.get_rotation().ln();
	pose[0]=translation[0];
	pose[1]=translation[1];
	pose[2]=translation[2];
    pose[3]=norm(rotation)/3.14159*360.0;
	pose[4]=rotation[0]/pose[3];
	pose[5]=rotation[1]/pose[3];
	pose[6]=rotation[2]/pose[3];
	return pose;
}

vector<float> System::getCurrentPoseInverse()
{
    SE3<> se3pose=mpTracker->GetCurrentPose();
    
    
    SE3<> nse=se3pose.inverse();
    nse.get_translation();
    
    vector<float> pose(16);
    Vector<3> translation,rotation;
    
    Matrix<3,3,double> RM=se3pose.inverse().get_rotation().get_matrix();
    
    
    translation=se3pose.inverse().get_translation();
    rotation=se3pose.inverse().get_rotation().ln();
    pose[0]=translation[0]; 
    pose[1]=translation[1];
    pose[2]=translation[2];
    pose[3]=norm(rotation)/3.14159*360.0;
    pose[4]=(rotation[0]/norm(rotation)/3.14159)*360.0;
    pose[5]=(rotation[1]/norm(rotation)/3.14159)*360.0;
    pose[6]=(rotation[2]/norm(rotation)/3.14159)*360.0;
    
    pose[7]=RM.my_data[0];
    pose[8]=RM.my_data[1];
    pose[9]=RM.my_data[2];
    pose[10]=RM.my_data[3];
    pose[11]=RM.my_data[4];
    pose[12]=RM.my_data[5];
    pose[13]=RM.my_data[6];
    pose[14]=RM.my_data[7];
    pose[15]=RM.my_data[8];

    return pose;
}

System::System()
{
  mpCamera = new ATANCamera("Camera");
  mpMap = new Map;
  mpMapMaker = new MapMaker(*mpMap, *mpCamera);
  mpTracker = new Tracker(ImageRef(640,480), *mpCamera, *mpMap, *mpMapMaker);  
  mimFrameBW.resize(ImageRef(640,480));
  mbDone = false;
};

void System::SendTrackerStartSig()
{
	mpTracker->StartTracking();
}

void System::SendTrackerKillSig()
{
	mpTracker->StopTracking();
}

void System::RunOneFrame(unsigned char *bwImage,uint hnd)
{
 // while(!mbDone)
  {
      //cout<<"IM run"<<endl;
      
      // Grab video frame in black and white from videobuffer
	mimFrameBW.copy_from(BasicImage<byte>(bwImage,ImageRef(640,480)));
//	bool bWasLocked = mpMap->mapLockManager.CheckLockAndWait( this, 0 );
    //  mGLWindow.SetupViewport();
    //  mGLWindow.SetupVideoOrtho();

	//glViewport(0, 0, 320, 480);
//	glMatrixMode(GL_PROJECTION);
//	glLoadIdentity();
//	glOrthof(0, 640, 480, 0, -1, 1);
//	
//    glMatrixMode(GL_MODELVIEW);
//    glLoadIdentity();
	//glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    //glClear(GL_COLOR_BUFFER_BIT);

    mpTracker->TrackFrame(mimFrameBW, hnd,1);
	
	
	
    string s=mpTracker->GetMessageForUser();
	UILabel *debugLabel=[[[UIApplication sharedApplication] delegate] userString];
	debugLabel.text=[NSString stringWithFormat:@"%s",s.c_str()];
  }

}

void System::GUICommandCallBack(void *ptr, string sCommand, string sParams)
{
  if(sCommand=="quit" || sCommand == "exit")
    static_cast<System*>(ptr)->mbDone = true;
}








