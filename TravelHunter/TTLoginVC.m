//
//  TTLoginVC.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "TTLoginVC.h"
#import "SVHTTPClient.h"
#import "TTMapVC.h"

@interface TTLoginVC (){
    NSUserDefaults *userDefault;
}
- (IBAction)touchLogin:(id)sender;

@end



@implementation TTLoginVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    NSString* uuid = [userDefault valueForKey:kUserUUID];
    
    self.nameText.delegate = self;
    
    if ([uuid length]>0) {
        NSString* userName = [userDefault valueForKey:kUserName];
        _nameText.text = userName;
        NSLog(@"welcome %@",userName);
        
        [self login:uuid];
        
    }
    else{
        [userDefault setValue:@"" forKey:kUserName];
        [userDefault synchronize];
        
        _nameText.text = @"";
    }
    
    [self initKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark keyboard
- (void)initKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [_scroller setContentOffset:CGPointMake(0, 150) animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [_scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_nameText resignFirstResponder];
    [self touchLogin:nil];
    
    return YES;
}

- (IBAction)touchLogin:(id)sender {
    if ([_nameText.text length] ==0) {
        ShowAlert(@"請輸入姓名");
    }
    else{
        //創新user
        NSDictionary*param = @{@"name":_nameText.text};
        
        [[SVHTTPClient sharedClient] POST:@"/user/" parameters:param completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
            
            
            NSLog(@"%@",response);
            NSString* uuid = [response valueForKey:@"uuid"];
            if ([uuid length]>0) {
                [userDefault setValue:uuid forKey:kUserUUID];
                [userDefault synchronize];
                [self login:uuid];
                
            }
            else{
                NSLog(@"NO UUID");
            }
        }];
    }
}

-(void)login:(NSString*)uuid{
    NSDictionary*param = @{@"uuid":uuid};
    
    [[SVHTTPClient sharedClient] POST:@"/login/" parameters:param completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            ShowAlert(@"login fail");
        }
        else{
            [self gotoMapVC:uuid];
        }
    }];
}
-(void)gotoMapVC:(NSString*)uuid{
    TTMapVC *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    mapVC.uuid = uuid;
    [self.navigationController pushViewController:mapVC animated:YES];

}
@end
