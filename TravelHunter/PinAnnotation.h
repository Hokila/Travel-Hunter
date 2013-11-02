//
//  PinAnnotation.h
//  SYM
//
//  Created by Hokila Jan on 2013/11/2.
//  Copyright (c) 2013年 Hokila Jan. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface PinAnnotation : NSObject <MKAnnotation>
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* upid;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
