//
//  ViewController.m
//  1-PlayBack
//
//  Created by Blayne Chong on 2016-01-30.
//  Copyright © 2016 Blayne Chong. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
{
    AVAudioSession *session;
    CABasicAnimation *flashingAnimation;
}
@end

@implementation RecordViewController

@synthesize recorder;
@synthesize player;

#pragma mark - View Instances
- (void)viewDidLoad {
    [super viewDidLoad];
    // setup documents directory where audio file will be saved
    NSArray *path = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"recording.m4a", nil];
    NSURL *outputURL = [NSURL fileURLWithPathComponents:path];
    
    // setup audio session
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    // configure record settings
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    
    // initiate recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputURL settings:recordSettings error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}


#pragma mark - Custom Methods
// Record button flashing animation
-(void)buttonFlashingAnimation: (UIButton *)button {
    flashingAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flashingAnimation.duration = 1.0;
    flashingAnimation.repeatCount = HUGE_VALF;
    flashingAnimation.autoreverses = NO;
    flashingAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    flashingAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [button.layer addAnimation:flashingAnimation forKey:@"animateOpacity"];
}

#pragma mark - Buttons
- (IBAction)recordButton:(id)sender {
    // begins and pasuses recording
    if (!recorder.recording) {
        [session setActive:YES error:nil];
        [recorder record];
        [self.recordButtonEnabled setTitle:@"PAUSE" forState:UIControlStateNormal];
        
        [self buttonFlashingAnimation:self.recordButtonEnabled];
    } else {
        [recorder pause];
        [self.recordButtonEnabled setTitle:@"RECORD" forState:UIControlStateNormal];
        [self.recordButtonEnabled.layer removeAllAnimations];
    }
    
    // enable stop button
    [self.stopButtonEnabled setEnabled:YES];
    [self.stopButtonEnabled setTitle:@"STOP" forState:UIControlStateNormal];
}

- (IBAction)stopButton:(id)sender {
    [recorder stop];
    [session setActive:NO error:nil];
}

#pragma mark - Delegates
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        [self.recordButtonEnabled setTitle:@"RECORD" forState:UIControlStateNormal];
        [self.recordButtonEnabled.layer removeAllAnimations];
        
        [self.stopButtonEnabled setEnabled:NO];
        [self.stopButtonEnabled setTitle:@"    " forState:UIControlStateDisabled];
    } else {
        NSLog(@"Error");
    }
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playRecording"]) {
        PlaybackViewController *playback = (PlaybackViewController *)segue.destinationViewController;
        playback.recorder = recorder;
    }
}


@end
