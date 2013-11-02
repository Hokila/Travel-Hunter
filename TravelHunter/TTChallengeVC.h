//
//  TTChallengeVC.h
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTChallengeVC : UIViewController
@property (nonatomic,strong) NSString* devilName;
@property (nonatomic,strong) NSMutableArray* qaArr;
@property (nonatomic,strong) NSString* bgURL;

//UI
@property (weak, nonatomic) IBOutlet UILabel *develLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
- (IBAction)clickBack:(id)sender;
@end
