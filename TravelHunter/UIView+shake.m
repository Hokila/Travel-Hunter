//
//  UIView+shake.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/3.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "UIView+shake.h"

@implementation UIView (shake)
#pragma -mark shake animation

const float interval = 1.0f;
const float shift = 10.0f;

-(void)shake{
    CGPoint center = self.center;
    CGPoint closeleftPoint = CGPointMake(center.x - shift, center.y);
    CGPoint closerightPoint = CGPointMake(center.x + shift, center.y);
    CGPoint leftPoint = CGPointMake(center.x - shift*2, center.y);
    CGPoint rightPoint = CGPointMake(center.x + shift*2, center.y);
    
    [self performSelector:@selector(moveTo:) withObject:NSStringFromCGPoint(closeleftPoint) afterDelay:0.2f];
    [self performSelector:@selector(moveTo:) withObject:NSStringFromCGPoint(closerightPoint) afterDelay:0.4f];
    [self performSelector:@selector(moveTo:) withObject:NSStringFromCGPoint(leftPoint) afterDelay:0.6f];
    [self performSelector:@selector(moveTo:) withObject:NSStringFromCGPoint(rightPoint) afterDelay:0.8f];
    [self performSelector:@selector(moveTo:) withObject:NSStringFromCGPoint(center) afterDelay:1.0f];
}

-(void)moveTo:(NSString*)pointStr{
    CGPoint aPoint = CGPointFromString(pointStr);
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.center= aPoint;
	
	[UIView commitAnimations];
}
@end
