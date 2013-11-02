//
//  TTFightVC.h
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTFightVC : UIViewController
@property (nonatomic,strong) NSString* devilName;

@property (weak, nonatomic) IBOutlet UIView *blurView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;


@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UILabel *develLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *infoSourceLink;
@property (weak, nonatomic) IBOutlet UIView *infoSourceView;

- (IBAction)clickBack:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *devilLab;

//從API拿到的資料
@property (nonatomic,strong) NSString* totalplayer;
@property (nonatomic,strong) NSString* bgURL;
@property (nonatomic,strong) NSString* iconURL;
@property (nonatomic,strong) NSString* vs_status;
@property (nonatomic,strong) NSMutableArray* picArr;

//wiki來的基本資料
@property (nonatomic,strong) NSDictionary* infoDic;

//氣象局來的
@property (nonatomic,strong) NSDictionary* weatherDic;

//問題集，答案都是第一個
@property (nonatomic,strong) NSMutableArray* qaArr;

//弱點分析
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextField;


- (IBAction)clickObserve:(id)sender;
- (IBAction)clickWeakAnalyze:(id)sender;
- (IBAction)clickChallenge:(id)sender;

@end
