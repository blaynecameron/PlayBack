//
//  ViewController.h
//  1-PlayBack
//
//  Created by Blayne Chong on 2016-01-30.
//  Copyright © 2016 Blayne Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PlaybackViewController.h"

@interface ViewController : UIViewController <AVAudioRecorderDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (weak, nonatomic) IBOutlet UIButton *stopButtonEnabled;
@property (weak, nonatomic) IBOutlet UIButton *recordButtonEnabled;

- (IBAction)recordButton:(id)sender;
- (IBAction)stopButton:(id)sender;

@end

