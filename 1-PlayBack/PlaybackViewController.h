//
//  PlaybackViewController.h
//  1-PlayBack
//
//  Created by Blayne Chong on 2016-01-30.
//  Copyright © 2016 Blayne Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlaybackViewController : UIViewController

@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) AVAudioPlayer *player;

- (IBAction)slowPlay:(id)sender;
- (IBAction)fastPlay:(id)sender;
- (IBAction)chipmunkPlay:(id)sender;
- (IBAction)vaderPlay:(id)sender;
- (IBAction)echoPlay:(id)sender;
- (IBAction)reverbPlay:(id)sender;


@end
