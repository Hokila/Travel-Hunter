//
//  BloodView.h
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(int, BloodType) {
	BTDevil,
    BTPlayer,
    BTPlayerTimer,
};

@class BloodView;

@protocol BloodViewDelegate <NSObject>
-(void)timeisEnd;
-(void)devilWin;
-(void)humanWin;

@end

@interface BloodView : UIView
@property(nonatomic) CGFloat blood; //剩餘血量
@property(nonatomic) CGFloat lostPerAttack; //Ex:40

@property(nonatomic) BloodType bloodtype;//d
@property(assign)id<BloodViewDelegate>delegate;

-(void)startCountDown;  //Timer才有
-(void)stop;        //Timer才有

-(void)getAttack;   //砍一刀
-(void)initialize;  //初始化
@end
