//
//  TTObserveVC.h
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTObserveVC : UIViewController <UIGestureRecognizerDelegate>
//UI
@property (nonatomic) NSString* name;

@property (weak, nonatomic) IBOutlet UILabel *develLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
- (IBAction)clickBack:(id)sender;

//

@property (weak, nonatomic) IBOutlet UIImageView *devilImageView ;
@property (nonatomic,strong) NSMutableArray* picArr;
@end
