//
//  TTChallengeVC.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "TTChallengeVC.h"

@interface TTChallengeVC ()

@end

@implementation TTChallengeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _develLabel.text = _devilName;
    [_bgImage loadImageWithURL:[NSURL URLWithString:_bgURL]];
    
    NSLog(@"qa有%d 題", [_qaArr count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
