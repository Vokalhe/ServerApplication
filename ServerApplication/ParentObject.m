//
//  ParentObject.m
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "ParentObject.h"

@implementation ParentObject

- (instancetype)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        NSString *urlStr = [dictionary objectForKey:@"url"];
        
        if ([urlStr hasPrefix:@"http"]) {
            self.url = [NSURL URLWithString:urlStr];
        }else{
            self.url = [NSURL fileURLWithPath:urlStr];
        }
        
        self.number = [dictionary objectForKey:@"number"];
    }
    return self;
}

@end
