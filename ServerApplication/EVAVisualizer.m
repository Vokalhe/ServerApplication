//
//  EVAVisualizer.h
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "EVAVisualizer.h"
#import "UIImage+Color.h"


#define kWidth 12
#define kHeight 50
#define kPadding 1

@interface EVAVisualizer ()

@property (nonatomic, strong) NSMutableArray *barArray;
@property (nonatomic, assign) NSInteger numberOfBars;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerColor;

@property (assign, nonatomic) __block NSInteger num;

@end

@implementation EVAVisualizer

- (id)initWithNumberOfBars:(int)numberOfBars {
    self = [super init];
    if (self) {
        
        
        self.barColor = [self randomColor];
        

        self.numberOfBars = numberOfBars/2;
        
        self.frame = CGRectMake(0, 0, kPadding*numberOfBars+(kWidth*numberOfBars), kHeight);
        
        NSMutableArray* tempBarArray = [[NSMutableArray alloc]initWithCapacity:numberOfBars];
        
       
        for(int i=0;i<numberOfBars;i++) {
            
            UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(i*kWidth+i*kPadding, 0, kWidth, 1)];
            
            bar.image = [UIImage imageWithColor:self.barColor];
            
            [self addSubview:bar];
            
            [tempBarArray addObject:bar];
            
        }
        
        [self.barArray removeAllObjects];
        self.barArray = [NSMutableArray arrayWithArray:tempBarArray];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2*2);
        
        self.transform = transform;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stopTimer" object:nil];
        
    }
    
    return self;
}

- (void)startTypeOfAnimations:(TypeAnimations) type {
    
    self.num = 0;

    [self.timer invalidate];
    [self.timerColor invalidate];
    self.timer = nil;
    self.timerColor = nil;

    self.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(ticker:) userInfo:[NSNumber numberWithInt:type] repeats:YES];
    self.timerColor = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for(UIImageView* bar in self.barArray) {
            [bar startAnimating];
            [bar setNeedsDisplay];
        }

    });
        
}

- (void)stop{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for(UIImageView* bar in self.barArray) {
            [bar stopAnimating];
            [bar setNeedsDisplay];
        }
    });
    
    
    [self.timer invalidate];
    [self.timerColor invalidate];
    self.timer = nil;
    self.timerColor = nil;

}

- (void)ticker:(NSTimer *)actualTimer {
    

    if (![self.timer isValid]) {
        NSLog(@"wqeqw %@ ", actualTimer);
        return;
    }
    
    if ([actualTimer.userInfo intValue] == 0) {
        
        [UIView animateWithDuration:0.35 animations:^{
            for(UIImageView* bar in self.barArray) {
                CGRect rect = bar.frame;
                rect.size.height = arc4random() % kHeight + 1;
                bar.frame = rect;
            }
        }];
        
    }else if ([actualTimer.userInfo intValue] == 1){
        
            [UIView animateWithDuration:0.3 animations:^{
                
                for(UIImageView* bar in self.barArray) {
                    NSArray* reversedArray = [[self.barArray reverseObjectEnumerator] allObjects];
                    
                    if ([reversedArray indexOfObject:bar] == self.num) {
                        CGRect rect = bar.frame;
                        rect.size.height = 60;
                        bar.frame = rect;
                        
                    }else if ([reversedArray count] - self.num == [reversedArray indexOfObject:bar]+1) {
                        
                        CGRect rect = bar.frame;
                        rect.size.height = 60;
                        bar.frame = rect;
                        
                    }else{
                        
                        CGRect rect = bar.frame;
                        rect.size.height = 5;
                        bar.frame = rect;
                        
                    }
                    
                }
                
            } completion:^(BOOL finished) {
                
                self.num++;
                if (self.num == 20) {
                    self.num = 0;
                }
                
            }];

            
    }else if ([actualTimer.userInfo intValue] == 2){
        
        [UIView animateWithDuration:0 delay:0.35 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            for(UIImageView* bar in self.barArray) {
                NSArray* reversedArray = [[self.barArray reverseObjectEnumerator] allObjects];

                if ([reversedArray indexOfObject:bar] == self.num) {
                    
                    CGRect rect = bar.frame;
                    rect.size.height = 15;
                    bar.frame = rect;
                    
                }else if ([reversedArray indexOfObject:bar] == self.num+1) {
                    
                    CGRect rect = bar.frame;
                    rect.size.height = 25;
                    bar.frame = rect;
                    
                }else if ([reversedArray indexOfObject:bar] == self.num+2) {
                
                    CGRect rect = bar.frame;
                    rect.size.height = 35;
                    bar.frame = rect;
                
                }else if ([reversedArray indexOfObject:bar] == self.num+3) {
                    
                    CGRect rect = bar.frame;
                    rect.size.height = 45;
                    bar.frame = rect;
                    
                }else if ([reversedArray indexOfObject:bar] == self.num+4) {
                    
                    CGRect rect = bar.frame;
                    rect.size.height = 55;
                    bar.frame = rect;
                    
                }else{
                    
                    CGRect rect = bar.frame;
                    rect.size.height = 5;
                    bar.frame = rect;
                    
                }
                
            }
            
        } completion:^(BOOL finished) {
            
            self.num++;
            if (self.num == 20) {
                self.num = 0;
            }
            
        }];
        
        
    }

    
    
    
}

-(void) changeColor{
    
    self.barColor = [self randomColor];

    [UIView animateWithDuration:1.5 animations:^{
        for(UIImageView* bar in self.barArray) {
            bar.image = [UIImage imageWithColor:self.barColor];
        }
    }];
    
}
-(UIColor*) randomColor{
    
    CGFloat red = (arc4random()%256)/255.0;
    CGFloat green = (arc4random()%256)/255.0;
    CGFloat blue = (arc4random()%256)/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
