//
//  TTMapVC.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "TTMapVC.h"
#import "TTFightVC.h"
#import "SVHTTPClient.h"
#import "TTAppDelegate.h"
#import "PinAnnotation.h"
@interface TTMapVC (){
    NSString* selectedupid;
}

@end

@implementation TTMapVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self performSelector:@selector(gotoEmptyFightPage) withObject:nil afterDelay:3.0];
    
	if (locmanager == nil) {
        locmanager = [[CLLocationManager alloc] init];
        [locmanager setDelegate:self];
        [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locmanager startUpdatingLocation];
    }
    else{
        [locmanager startUpdatingLocation];
    }
    
    self.devilView.hidden = YES;
    self.devilMap.delegate = self;
    
    //disable
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    TTAppDelegate* app = [TTAppDelegate sharedAppDelegate];
    if (app.userLocation ==nil) {
        app.userLocation = newLocation;
        [self loadNearestSpot];
    }
    else{
        //離開超過5公里再re call
        if ([newLocation distanceFromLocation:app.userLocation] > 5000) {
            app.userLocation = newLocation;
            
            [self loadNearestSpot];
        }
    }
}

-(void)loadNearestSpot{
    NSLog(@"loadNearestSpot");
    
    //設定地圖大小
    CLLocation *location = [TTAppDelegate sharedAppDelegate].userLocation;
    _devilMap.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 200 , 200);
    
    [self.devilMap removeAnnotations:_annotationList];
    
    latValue = location.coordinate.latitude;
    lngValue = location.coordinate.longitude;
    NSString* uuid = [[NSUserDefaults standardUserDefaults] valueForKey:kUserUUID];
    
    
    NSDictionary*param = @{@"lat":[NSString stringWithFormat:@"%f",latValue],
                           @"lng":[NSString stringWithFormat:@"%f",lngValue],
                           @"uuid":uuid};
    
    [[SVHTTPClient sharedClient] GET:@"/place/" parameters:param completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            ShowAlert(@"get place fail");
        }
        else{
            [_annotationList removeAllObjects];
            
            NSLog(@"%@",response);
            
            _annotationList = response;
            [self showAnnotation];
        }
    }];
}

-(void)showAnnotation{
    if ([_annotationList count] ==0) {
        ShowAlert(@"抱歉 無怪可打 \n 不過你可以打kevin")
        return;
    }
    
    [_annotationList enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
//        NSString* icon = [dic valueForKey:@"icon"];
//        NSString* pinStr = [dic valueForKey:@"pin"];
        NSString* name = [dic valueForKey:@"name"];
        
        CLLocation *location = [self getPosition:[dic valueForKey:@"position"]];
        NSString* upid = [dic valueForKey:@"upid"];
        NSString* vs_status = [dic valueForKey:@"vs_status"];
        NSLog(@"%@ %@ %@ ",name,upid,vs_status);
        
        PinAnnotation *pin = [[PinAnnotation alloc]init];
        pin.coordinate = location.coordinate;
        pin.name = name;
        pin.upid = upid;
        
        [_devilMap addAnnotation:pin];
    }];
}

-(CLLocation*)getPosition:(NSDictionary*)position{
    latValue = [[position valueForKey:@"lat"] floatValue];
    lngValue = [[position valueForKey:@"lng"] floatValue];
    
    return [[CLLocation alloc]initWithLatitude:latValue longitude:lngValue];
}

#pragma -mark mapView delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annotationView;
    NSString *identifier = @"THPin";
    
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        //do nothing
    }
    
    if ([annotation isKindOfClass:[PinAnnotation class]]){
        PinAnnotation* pin = (PinAnnotation*)annotation;
        
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        annotationView.canShowCallout = NO;
        
        //find pin png
        [_annotationList enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop) {
            if ([[dic valueForKey:@"name"] isEqualToString:pin.name]) {
//                NSString* pinStr = [NSString stringWithFormat:@"%@%@",TTbasePath ,[dic valueForKey:@"pin"]];
                UIImage *pinImg = [UIImage imageNamed:@"yahoo_pin"];
                
                annotationView.image = pinImg;
                *stop = YES;
            }
        }];
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[MKUserLocation class]])
        return;
    
    //藏起來的話 就秀出來
    if (_devilView.hidden == YES) {
        PinAnnotation* customAnnotation = view.annotation;
        //    CGPoint annotationPoint = [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView];
        
        [_annotationList enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop) {
            if ([[dic valueForKey:@"name"] isEqualToString:customAnnotation.name]) {
                _devilView.hidden = NO;
                
                //拿到魔王名字跟id
                _devilName.text = customAnnotation.name;
                selectedupid = [dic valueForKey:@"upid"];
                
                NSString* iconURL = [NSString stringWithFormat:@"%@%@",TTbasePath,[dic valueForKey:@"icon"]];
                NSURL* aURL = [NSURL URLWithString:iconURL];
                NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
                _devilIcon.image = [UIImage imageWithData:data];
                
                //store iconURL
                [[NSUserDefaults standardUserDefaults]setValue:iconURL forKey:kIconImage];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                *stop = YES;
            }
        }];
    }
    else{
        _devilView.hidden = YES;
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 按下戰鬥
- (IBAction)clickEnter:(id)sender {
    
//    假資料
//    selectedupid = @"boKuhDdK8sxVN3pg8cCT5BXwFuqsYZxR";
//    _uuid = @"cvrGtHwCtJD3XzY9BcviX6fl4W6lNhSe";
    
    NSString* urlPath = [NSString stringWithFormat:@"/place/%@",selectedupid];
    NSDictionary*param = @{@"uuid":_uuid};
    
    //拿魔王詳細資料，開始loading
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"載入魔王資料";
	[HUD show:YES];
	
//    sample
//    http://yahoo-hackday.herokuapp.com/place/boKuhDdK8sxVN3pg8cCT5BXwFuqsYZxR?uuid=cvrGtHwCtJD3XzY9BcviX6fl4W6lNhSe
    
    
    [[SVHTTPClient sharedClient] GET:urlPath parameters:param completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [HUD hide:YES];
        
        //結束loading
        if (error) {
            NSLog(@"%@",error);
            ShowAlert(@"get place info fail");
        }
        else{
            NSLog(@"%@",response);
            [self gotoFightPage:response];
        }
    }];

}
- (void)gotoEmptyFightPage{
    TTFightVC *fight = [self.storyboard instantiateViewControllerWithIdentifier:@"FightVC"];
    [self.navigationController pushViewController:fight animated:YES];
}

- (void)gotoFightPage:(id)response{
    TTFightVC *fight = [self.storyboard instantiateViewControllerWithIdentifier:@"FightVC"];
    
    fight.devilName = self.devilName.text;
    fight.totalplayer = [response valueForKey:@"totalplayer"];
    fight.bgURL = [TTbasePath stringByAppendingString:response[@"bg"]];
    fight.iconURL = [TTbasePath stringByAppendingString:response[@"icon"]];
    fight.vs_status = response[@"vs_status"];
    fight.picArr = response[@"pic"];
    fight.infoDic = response[@"info"];
    fight.weatherDic = response[@"weather"];
    fight.qaArr = response[@"qa"];
    
    [self.navigationController pushViewController:fight animated:YES];
}
@end
