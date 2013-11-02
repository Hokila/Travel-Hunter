//
//  TTMapVC.h
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TTMapVC : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    
    CGFloat latValue,lngValue;
    CLLocationManager *locmanager;
}

@property (strong,nonatomic) NSString* uuid;
@property (strong,nonatomic) NSMutableArray *annotationList;
@property (weak, nonatomic) IBOutlet MKMapView *devilMap;

@property (weak, nonatomic) IBOutlet UIView *devilView;
@property (weak, nonatomic) IBOutlet UILabel *devilName;
@property (weak, nonatomic) IBOutlet UIImageView *devilIcon;


- (IBAction)clickEnter:(id)sender;

@end
