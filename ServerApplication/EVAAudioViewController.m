//
//  EVAAudioViewController.m
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/11/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "EVAAudioViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "EVAVisualizer.h"
#import "ParentObject.h"



@interface EVAAudioViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ibImage;
@property (weak, nonatomic) IBOutlet UILabel *ibLabel;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) EVAVisualizer *equalizer;

@property (assign, nonatomic) NSTimeInterval lastTimeAudio;
@property (strong, nonatomic) NSString *path;

@property (assign, nonatomic) NSInteger countOfTap;

@end

@implementation EVAAudioViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    self.countOfTap = 0;
    
    self.ibLabel.text = [NSString stringWithFormat:@"name: %@", [self.audio.name substringWithRange:NSMakeRange(0, self.audio.name.length-4)]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    self.ibTitle.title = self.titleAudio;
    [self playAudioWithURL:self.url];
    
    self.type = [self readTypeFromPlistPath:self.path];
    self.countOfTap = self.type;
    
    [self createEqualizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.lastTimeAudio = self.audioPlayer.currentTime;
    [self writeToPlistPath:self.path];

    NSLog(@"currentTime %f",self.lastTimeAudio);
    
}

#pragma mark - Actions
- (IBAction)actionPause:(id)sender {
    
    [self.equalizer stop];
    [self.audioPlayer pause];
    
}

- (IBAction)actionStopAndRefreshSound:(id)sender {
    
    [self.audioPlayer stop];
    self.audioPlayer.currentTime = 0;
    [self startEqualizer];
    [self.audioPlayer play];

}

- (IBAction)actionPlay:(id)sender {
    
    
    [self startEqualizer];
    [self.audioPlayer play];

    

}

- (IBAction)actionBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - Handle Tap 

-(void) handleTap:(UITapGestureRecognizer*) tap{
    
    self.countOfTap++;
    if (self.countOfTap > 2) {
        self.countOfTap = 0;
    }
    NSLog(@"%d", self.type);

    switch (self.countOfTap) {
        case 0:
            self.type = TypeAnimationsFirst;
            [self.equalizer startTypeOfAnimations:self.type];
            break;
        case 1:
            self.type = TypeAnimationsSecond;
            [self.equalizer startTypeOfAnimations:self.type];
            break;
        case 2:
            self.type = TypeAnimationsThird;
            [self.equalizer startTypeOfAnimations:self.type];
            break;
    
        default:
            break;
    }
    [self.audioPlayer play];

}

#pragma mark - Private Method

-(void) startEqualizer{
    [self.equalizer startTypeOfAnimations:self.type];
}
-(void) createEqualizer{
    
    self.equalizer = [[EVAVisualizer alloc]initWithNumberOfBars:20];
    
    CGRect frame = self.equalizer.frame;
    frame.origin.x = (self.view.frame.size.width - self.equalizer.frame.size.width)/2;
    frame.origin.y = (self.view.frame.size.height - self.equalizer.frame.size.height*2.5);
    self.equalizer.frame = frame;
    
    [self.view addSubview:self.equalizer];
    
    [self startEqualizer];
    
}
-(void) playAudioWithURL:(NSURL*) url{
    
    NSString* path =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,    NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:self.audio.name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    NSURL *audioURL;
    
    if (fileExists) {
        audioURL = [NSURL fileURLWithPath:path];
        self.lastTimeAudio = 0;
    } else {
        audioURL = url;
        self.lastTimeAudio = [self readFromPlistPath:self.path];
    }
    
    NSString *tempString = [NSString stringWithFormat:@"%@", audioURL];
    tempString = [tempString substringWithRange:NSMakeRange(6, tempString.length-6)];
    
    NSURL *soundUrl = [NSURL fileURLWithPath:tempString];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    if ((int)self.lastTimeAudio == (int)self.audioPlayer.duration) {
        self.lastTimeAudio = 0.0;
    }
    
    self.audioPlayer.currentTime = self.lastTimeAudio;
   
    AVAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    for (AVMetadataItem *metadataItem in asset.commonMetadata) {
        
        if ([metadataItem.commonKey isEqualToString:@"artwork"]){
            NSData *imageData = nil;
            id value = metadataItem.value;
            if ([value isKindOfClass:[NSData class]]){
                     imageData = (NSData *)value;
                 }else if ([value isKindOfClass:[NSDictionary class]]){
                     imageData = [(NSDictionary *)value objectForKey:@"data"];
                 }
            UIImage *image = [UIImage imageWithData:imageData];
            [self.ibImage setImage:image];
        }
        
        if ([[metadataItem commonKey] isEqualToString:@"title"]) {
            NSString *str = (NSString *)[metadataItem value];
            if (str != nil) {
                self.ibLabel.text = [NSString stringWithFormat:@"name: %@", str];
            }
        }
    }
    
    [self.audioPlayer play];
    
}

-(NSTimeInterval) readFromPlistPath:(NSString*) path{
    //read
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    double value = [[savedStock objectForKey:self.audio.name] doubleValue];
    return value;
    
}

-(TypeAnimations) readTypeFromPlistPath:(NSString*) path{
    //read
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    int value = [[savedStock objectForKey:@"type"] intValue];
    return value;
    
}
-(void) writeToPlistPath:(NSString*) path{
    //write
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    [data setObject:[NSNumber numberWithDouble:self.lastTimeAudio] forKey:self.audio.name];
    [data setObject:[NSNumber numberWithInt:self.type] forKey:@"type"];

    [data writeToFile: path atomically:YES];
}
@end
