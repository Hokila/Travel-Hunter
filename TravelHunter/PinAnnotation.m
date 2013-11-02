//
//  PinAnnotation.m
//  SYM
//
//  Created by Hokila Jan on 2013/11/2.
//  Copyright (c) 2013年 Hokila Jan. All rights reserved.
//
//#import "SYMDelegate.h"

#import "PinAnnotation.h"

@implementation PinAnnotation


// required if you set the MKPinAnnotationView's "canShowCallout" property to YES

- (NSString *)title
{
    return self.name;
}

// optional
//- (NSString *)subtitle
//{
//    return self.addr;
//}

@end
