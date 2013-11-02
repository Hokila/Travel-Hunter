//
//  TTChallengeVC.h
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodView.h"

@interface TTChallengeVC : UIViewController <BloodViewDelegate>
//var used for init
@property (nonatomic,strong) NSString* devilName;
@property (nonatomic,strong) NSMutableArray* qaArr;
@property (nonatomic,strong) NSString* bgURL;

//baic UI
@property (weak, nonatomic) IBOutlet UILabel *develLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
- (IBAction)clickBack:(id)sender;

//專屬UI
@property (weak, nonatomic) IBOutlet UIView *pkView;
@property (weak, nonatomic) IBOutlet UIView *bossView;
@property (weak, nonatomic) IBOutlet UIView *quView;
@property (weak, nonatomic) IBOutlet UIView *heroView;
@property (weak, nonatomic) IBOutlet UIView *choiceView;

//各View上的細項
//血條系列
@property (weak, nonatomic) IBOutlet BloodView *bossBlood;
@property (weak, nonatomic) IBOutlet BloodView *heroBlood;
@property (weak, nonatomic) IBOutlet BloodView *timeCounter;

//倒數計時
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

//問題
@property (weak, nonatomic) IBOutlet UITextView *quTextField;
- (IBAction)clickAnswer:(id)sender;

@end
