//
//  TTFightVC.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "TTFightVC.h"
#import "UIImageView+ImageCache.h"
#import <CoreImage/CoreImage.h>
#import "TTObserveVC.h"
#import "TTChallengeVC.h"


@interface TTFightVC ()

@end

@implementation TTFightVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.blurView.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.develLabel.text = _devilName;
    self.title = _devilName;
    
    [_iconImage loadImageWithURL:[NSURL URLWithString:_iconURL]];
    [_bgImage loadImageWithURL:[NSURL URLWithString:_bgURL]];
    
    [self loadvs_Status];
//    [self loadBlurImage];
    
    //change infoView
    CGFloat height = _infoView.frame.size.height;
    CGFloat sourceheight = _infoSourceView.frame.size.height;
    _infoTextField.frame = CGRectMake(10, 10, 300, height - 20 - sourceheight);
    
    //change
    CGFloat sourceViewHeight = CGRectGetHeight(_infoTextField.frame) + _infoTextField.frame.origin.y;
    _infoSourceView.frame = CGRectMake(10, sourceViewHeight, 300, 25);
    
    [[NSUserDefaults standardUserDefaults]setValue:_vs_status forKey:kUserVS];
    
    
}

-(void)loadvs_Status{
    if (_vs_status == nil) {
        return;
    }
    
    NSInteger status = [_vs_status integerValue];
    switch (status) {
        case 0:
            _devilLab.text = @"新魔王，要挑戰看看嗎？" ;
            break;
        case 1:
            _devilLab.text = @"你還沒打贏過他，再挑戰一次？" ;
            break;
        default:
            _devilLab.text = [NSString stringWithFormat:@"上次花了%d秒，要再挑戰一次嗎？",status] ;
            break;
    }
}

-(void)loadBlurImage{
//    CIImage *coreSourceImage = [CIImage imageWithCGImage:sourceImage.CGImage]; CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [blurFilter setValue:coreSourceImage forKey:kCIInputImageKey];
//    [blurFilter setValue:@5.0f forKey:@"inputRadius"];
//    CIImage *resultCoreImage = [blurFilter outputImage];
//    CGImageRef cgImageRef = [_context createCGImage:resultCoreImage fromRect:coreSourceImage.extent];
//     _blurImage.image = [UIImage imageWithCGImage:cgImageRef]; CGImageRelease(cgImageRef);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickObserve:(id)sender {
//    ShowAlert(@"API還沒寫好啦");
    TTObserveVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TTObserve"];
    //add rest code
    vc.name = _devilName;
    vc.picArr = _picArr;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickWeakAnalyze:(id)sender {
//    ShowAlert(@"kevin的弱點是....");
    if (_infoView.hidden) {
        [_infoBtn setBackgroundImage:[UIImage imageNamed:@"under_bar_clicked_btn"] forState:UIControlStateNormal];
        self.infoTextField.text = _infoDic[@"desc"];
        [_infoSourceLink setTitle:_infoDic[@"source"] forState:UIControlStateNormal];
        [_infoSourceLink addTarget:self action:@selector(showLink) forControlEvents:UIControlEventTouchUpInside];
        
        _infoView.hidden = NO;
    }
    else{
        [_infoBtn setBackgroundImage:[UIImage imageNamed:@"under_bar_btn"] forState:UIControlStateNormal];
        _infoView.hidden = YES;
    }

}

-(void)showLink{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_infoDic[@"link"]]];
}

- (IBAction)clickChallenge:(id)sender {
//    ShowMyAlert(@"真的要挑戰嗎", @"真的", @"我還是回家練練吧");
    TTChallengeVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TTChallenge"];
    vc.devilName = _devilName;
    vc.qaArr = _qaArr;
    vc.bgURL = _bgURL;
    vc.vs_status = [_vs_status integerValue];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
