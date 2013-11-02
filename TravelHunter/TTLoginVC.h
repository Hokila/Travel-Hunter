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
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameText;

@end
