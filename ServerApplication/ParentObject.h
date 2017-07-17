//
//  ParentObject.h
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSNumber *number;

- (instancetype)initWithDictionary:(NSDictionary*) dictionary;

@end
