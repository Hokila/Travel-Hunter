//
//  BloodView.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "BloodView.h"

@implementation BloodView{
    CGFloat totalBlood;
    CGFloat leftBlood;
    
    CGFloat totalWidth;
    CGFloat leftWidth;
    
    NSTimer *countdownTimer;
    CGFloat leftTime;
}

const float totalTime = 10;

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    UIView* whiteView = [self superview];
    self.frame = whiteView.bounds;
    
    
    totalBlood = leftBlood = 100;
    totalWidth = leftWidth = self.frame.size.width;
    
    
}

- (void)drawRect:(CGRect)rect
{
    switch (_bloodtype) {
        case BTDevil:
            self.backgroundColor = [UIColor redColor];
            break;
        case BTPlayer:
            self.backgroundColor = [UIColor blueColor];
            break;
        case BTPlayerTimer:
            self.backgroundColor = [UIColor purpleColor];
            break;
        default:
            break;
    }
}

-(CGFloat)blood{
    return leftBlood;
}


-(void)startCountDown{
    if (self.bloodtype != BTPlayerTimer) {
        return;
    }
    
    [self initCountdownTimer];
}

-(void)initCountdownTimer{
    leftTime = totalTime;
    totalWidth = leftWidth = self.frame.size.width;
    
    [countdownTimer invalidate];
    
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(countDown)
                                                    userInfo:nil
                                                     repeats:YES];
    leftTime = 10;
}
-(void)countDown{
    leftTime = leftTime -0.1;
    
    //更新時間
    [self updateWidth:[self timeToWidth]];
    
    if (leftTime <=0) {
        [self stop];
        [self.delegate performSelector:@selector(timeisEnd) withObject:nil];
    }
}

-(void)stop{
    if ([countdownTimer isValid]) {
        [countdownTimer invalidate];
    }
}


-(void)getAttack{
    if (self.bloodtype == BTPlayerTimer) {
        return;
    }
    if (self.lostPerAttack ==0) {
        return;
    }
    
    leftBlood = leftBlood - _lostPerAttack;
    
    
    if (leftBlood <0) {
        if (self.bloodtype == BTDevil) {
            [self.delegate performSelector:@selector(humanWin) withObject:nil];
        }
        else{
            [self.delegate performSelector:@selector(devilWin) withObject:nil];
        }
    }
    
    //更新血條
    [self updateWidth:[self bloodToWidth:leftBlood]];
}


//轉換公式
-(CGFloat)bloodToWidth:(CGFloat)blood{
    return (blood/totalBlood)*totalWidth;
}

-(CGFloat)widthToBlood:(CGFloat)width{
    return (width/totalWidth )*totalBlood;
}

-(CGFloat)timeToWidth{
    return (leftTime/totalTime)*totalWidth;
}

-(void)updateWidth:(CGFloat)width{
    CGFloat height = self.bounds.size.height;
    
    if (_bloodtype == BTDevil) {
        CGFloat lostTotalWidth = totalWidth - [self bloodToWidth:leftBlood];
        leftWidth = totalWidth - lostTotalWidth;
        self.frame = CGRectMake(lostTotalWidth, 0, leftWidth, height);
    }
    else{
        self.frame = CGRectMake(0, 0, width, height);
    }
    
}
@end
