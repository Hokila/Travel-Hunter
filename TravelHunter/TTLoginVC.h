//
//  TTLoginVC.h
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TTAppDelegate.h"

@interface TTLoginVC : UIViewController<UITextFieldDelegate>{
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, assign) CGRect inputArea;

- (IBAction)touchLogin:(id)sender;

@end
