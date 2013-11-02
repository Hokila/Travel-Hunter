//
//  TTObserveVC.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "TTObserveVC.h"
#import "TTFightVC.h"

@interface TTObserveVC ()

@end

@implementation TTObserveVC
@synthesize devilImageView;


NSMutableArray *devilImages;
NSInteger showingCount = 0;

-(void) showHideNavbar:(id) sender
{
    // write code to show/hide nav bar here
    // check if the Navigation Bar is shown
    if (self.navigationController.navigationBar.hidden == NO)
    {
        // hide the Navigation Bar
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    // if Navigation Bar is already hidden
    else if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)leftSwipeGesture:(UISwipeGestureRecognizer *)sender
{
    showingCount = (++showingCount >= devilImages.count) ? --showingCount : showingCount;
    devilImageView.image = devilImages[showingCount];
}

- (void)rightSwipeGesture:(UISwipeGestureRecognizer *)sender
{
    showingCount = (--showingCount <= 0) ? 0 : --showingCount;
    devilImageView.image = devilImages[showingCount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[_iconImage loadImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kIconImage]]];
    _develLabel.text = _name;
    
    devilImageView.backgroundColor = [UIColor clearColor];
    devilImageView.userInteractionEnabled = YES;
    devilImageView.image = [UIImage imageNamed:@"oops00.jpg"];


    devilImages = [[NSMutableArray alloc]init];
    
    
    devilImages = [NSMutableArray arrayWithArray: @[[UIImage imageNamed:@"yahoo00.jpg"],
                                                    [UIImage imageNamed:@"yahoo01.jpg"],
                                                    [UIImage imageNamed:@"yahoo02.jpg"],
                                                    [UIImage imageNamed:@"yahoo03.jpg"],
                                                    [UIImage imageNamed:@"yahoo04.jpg"],
                                                    [UIImage imageNamed:@"yahoo05.jpg"]]];

    if (devilImages.count > 0) {
        devilImageView.image = devilImages[0];
        showingCount = 0;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(showHideNavbar:)];

    [devilImageView addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *leftswipeGesture = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(leftSwipeGesture:)];
    
    [leftswipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [devilImageView addGestureRecognizer:leftswipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(rightSwipeGesture:)];
    
    [rightSwipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [devilImageView addGestureRecognizer:rightSwipeGesture];
    
//    ShowAlert(@"滑動看更多!!!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
