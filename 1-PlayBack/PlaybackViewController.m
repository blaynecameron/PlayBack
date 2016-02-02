//
//  PlaybackViewController.m
//  1-PlayBack
//
//  Created by Blayne Chong on 2016-01-30.
//  Copyright © 2016 Blayne Chong. All rights reserved.
//

#import "PlaybackViewController.h"

@interface PlaybackViewController ()
{
    AVAudioEngine *engine;
    AVAudioPlayerNode *playerNode;
    AVAudioUnitTimePitch *changePitch;
    AVAudioFile *audioFile;
    AVAudioUnitDelay *echoNode;
    AVAudioUnitReverb *reverbNode;
}
@end

@implementation PlaybackViewController

@synthesize player;
@synthesize recorder;

#pragma mark - View Events
- (void)viewDidLoad {
    [super viewDidLoad];
    
    engine = [[AVAudioEngine alloc] init];
    
}

#pragma mark - Custom Method
-(void)playRate: (float)playSpeed {
    [player stop];
    [playerNode stop];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
    
    if ([player respondsToSelector:@selector(setEnableRate:)]) {
        player.enableRate = YES;
    }
    
    if ([player respondsToSelector:@selector(setRate:)]) {
        player.rate = playSpeed;
    }
    
    // sets player delegate to self
    [player play];
}

-(void)pitchChange: (float)pitchCents {
    [self audioEngineAndNodeSetup];
    
    // sets the pitch of the playback
    changePitch = [[AVAudioUnitTimePitch alloc] init];
    changePitch.pitch = pitchCents;
    [engine attachNode:changePitch];
    
    // connects the player to the effect
    [engine connect:playerNode to:changePitch format:nil];
    
    // connects the effect to the speakers
    [engine connect:changePitch to:engine.outputNode format:nil];
    
    [self playNodes];
}

-(void)audioEngineAndNodeSetup {
    [player stop];
    [playerNode stop];
    
    // stops audio engine and resets nodes
    [engine stop];
    [engine reset];
    
    playerNode = [[AVAudioPlayerNode alloc] init];
    [engine attachNode:playerNode];
    
    NSError *error;
    audioFile = [[AVAudioFile alloc] initForReading:recorder.url error:&error];
    NSLog(@"%@", error);
}

-(void)playNodes {
    [playerNode scheduleFile:audioFile atTime:nil completionHandler:nil];
    [engine startAndReturnError:nil];
    [playerNode play];
}

#pragma mark - Buttons
- (IBAction)slowPlay:(id)sender {
    [self playRate:0.5f];
}

- (IBAction)fastPlay:(id)sender {
    [self playRate:2.0f];
}

- (IBAction)chipmunkPlay:(id)sender {
    [self pitchChange:1000.0];
}

- (IBAction)vaderPlay:(id)sender {
    [self pitchChange:-1000.0];
}

- (IBAction)echoPlay:(id)sender {
    [self audioEngineAndNodeSetup];
    
    NSTimeInterval timeInterval = 0.3;
    echoNode = [[AVAudioUnitDelay alloc] init];
    echoNode.delayTime = timeInterval;
    [engine attachNode:echoNode];
    
    [engine connect:playerNode to:echoNode format:nil];
    [engine connect:echoNode to:engine.outputNode format:nil];
    
    [self playNodes];
}

- (IBAction)reverbPlay:(id)sender {
    [self audioEngineAndNodeSetup];
    
    reverbNode = [[AVAudioUnitReverb alloc] init];
    [reverbNode loadFactoryPreset:AVAudioUnitReverbPresetLargeChamber];
    reverbNode.wetDryMix = 100.0;
    [engine attachNode:reverbNode];
    
    [engine connect:playerNode to:reverbNode format:nil];
    [engine connect:reverbNode to:engine.outputNode format:nil];
    
    [self playNodes];
}



@end
