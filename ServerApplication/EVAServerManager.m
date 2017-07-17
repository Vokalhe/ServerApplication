//
//  EVAServerManager.m
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "EVAServerManager.h"
#import "AFNetworking.h"

@interface EVAServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *requestSessionManager;

@end

@implementation EVAServerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888"];
        self.requestSessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:url];

    }
    return self;
}


@end
