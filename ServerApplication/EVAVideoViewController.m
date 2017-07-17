//
//  EVAVideoViewController.m
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/11/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "EVAVideoViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "ParentObject.h"

@interface EVAVideoViewController ()

@property (assign, nonatomic) CMTime lastTime;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSString *path;

@end

@implementation EVAVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    [self playVideoWithURL:self.url];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) playVideoWithURL:(NSURL*) url{
    
    NSString* path =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,    NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:self.video.name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    NSURL *videoURL;
    
    if (fileExists) {
        videoURL = [NSURL fileURLWithPath:path];
        self.lastTime = CMTimeMake(0, 1);
    } else {
        videoURL = url;
        self.lastTime = [self readFromPlistPath:self.path];
    }

    self.player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    controller.player = self.player;
    
    if ((int)CMTimeGetSeconds(self.lastTime) == (int)CMTimeGetSeconds(self.player.currentItem.asset.duration)) {
        self.lastTime = CMTimeMake(0, 1);
    }
    
    [self.player seekToTime:self.lastTime];
    
    double runningTime = CMTimeGetSeconds(self.player.currentTime);
    NSLog(@"currentTime %f",runningTime);
    
    [self.player play];
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.frame = self.view.frame;
    
    
}

- (void)dealloc
{
    self.lastTime = self.player.currentTime;
    double runningTime = CMTimeGetSeconds(self.lastTime);
    [self writeToPlistPath:self.path];
    
    NSLog(@"currentTime %f",runningTime);

}

-(CMTime) readFromPlistPath:(NSString*) path{
    //read
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    double value = [[savedStock objectForKey:self.video.name] doubleValue];
    CMTime valueTime = CMTimeMake(value, 1);
    return valueTime;
    
}

-(void) writeToPlistPath:(NSString*) path{
    //write
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    double runningTime = CMTimeGetSeconds(self.lastTime);
    [data setObject:[NSNumber numberWithDouble:runningTime] forKey:self.video.name];
    
    [data writeToFile: path atomically:YES];
}

@end
