//
//  TTChallengeVC.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "TTChallengeVC.h"

typedef NS_ENUM(int, QuestionType) {
	Q_TF,
    Q_Choice,
};

@interface TTChallengeVC (){
    NSInteger totalQuestion;
    NSInteger currentQuestion;
    QuestionType currentQuestiontype;
    
    NSInteger correctAnswerIndex;
    NSMutableArray* currentAnswerArr;
    
    NSTimer *totalTimer;   //總共的時間
    CGFloat totalTime;
    
    BOOL isGameEnd;
}
@end

@implementation TTChallengeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _develLabel.text = _devilName;
    [_bgImage loadImageWithURL:[NSURL URLWithString:_bgURL]];
    
//    NSLog(@"qa有%d 題", [_qaArr count]);
    
    [self setupView];
    [self initVariable];
    
    [self startFight];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timeCounter stop];
    
    if ([totalTimer isValid]) {
        [totalTimer invalidate];
    }
}

-(void)startFight{
    [self loadQuestion:currentQuestion];
    [self initTimer];
}

-(void)initTimer{
    [totalTimer invalidate];
    totalTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(updateTimeLabel)
                                                userInfo:nil
                                                 repeats:YES];
    totalTime = 0;
    
}

-(void)updateTimeLabel{
    totalTime = totalTime +0.1;

    NSInteger c = (int)((totalTime -(int)totalTime )*10);
    NSInteger s = (int)totalTime %60;
    NSInteger m = (int)totalTime /60;
    self.totalLabel.text = [NSString stringWithFormat:@"%02d:%02d.%d",m,s,c];
}

-(void)loadQuestion:(NSInteger)questionIndex{
    NSDictionary* quDic = _qaArr[questionIndex];
    NSString* questionStr = quDic[@"question"];
    
    //顯示題目
    self.quTextField.text = [NSString stringWithFormat:@"Q%d:%@",questionIndex +1,questionStr];
    
    currentQuestiontype = [self getQuestiontype:quDic];
    correctAnswerIndex = [quDic[@"correctIndex"] integerValue] +100;
    
    [self setupChoiceView:currentQuestiontype];
    
    [self.timeCounter startCountDown];
}

-(void)setupChoiceView:(QuestionType)Questiontype{
    UIButton* choice1 = (UIButton*)[_choiceView viewWithTag:100];
    UIButton* choice2 = (UIButton*)[_choiceView viewWithTag:101];
    UIButton* choice3 = (UIButton*)[_choiceView viewWithTag:102];
    
    for (UIButton* btn in _choiceView.subviews) {
        btn.hidden = NO;
    }
    
    if (Questiontype == Q_TF) {
        choice3.hidden = YES;
    }

    NSMutableArray* choiceList = [@[choice1,choice2,choice3]mutableCopy];

    [currentAnswerArr enumerateObjectsUsingBlock:^(NSString* answer, NSUInteger idx, BOOL *stop) {
        UIButton* btn = choiceList[idx];
        [btn setTitle:answer forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"fight_choose_btn"] forState:UIControlStateNormal];
    }];
}


-(QuestionType)getQuestiontype:(NSDictionary*)quDic{
    currentAnswerArr = quDic[@"answer"];
    BOOL isContainYES = NO,isContainNO = NO;
    
    for (NSString* option in currentAnswerArr) {
        if ([[option lowercaseString] isEqualToString:@"yes"]) {
            isContainYES = YES;
        }
        
        if ([[option lowercaseString] isEqualToString:@"no"]) {
            isContainNO = YES;
        }
    }
    
    if (isContainYES && isContainNO) {
        return Q_TF;
    }
    else{
        return Q_Choice;
    }
}

-(void)gotoNextQuestion{
    //不考慮題目完了王還沒死的情形
    if (isGameEnd) {
        return;
    }
    
    currentQuestion ++;
    if (currentQuestion >= [_qaArr count]) {
        ShowAlert(@"沒題目了啦")
    }
    else{
        [self loadQuestion:currentQuestion];
    }
}

-(void)setupView{
    //setup View
    [_iconImage loadImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]valueForKey:kIconImage ]]];
    
    _quView.hidden = NO;
    _winloseView.hidden = YES;
    
//    _quView.center =  _pkView.center;
//    _winloseView.center = self.view.center;
    
    self.heroBlood.bloodtype = BTPlayer;
    self.bossBlood.bloodtype = BTDevil;
    self.timeCounter.bloodtype = BTPlayerTimer;
    
    self.heroBlood.delegate = self;
    self.bossBlood.delegate = self;
    self.timeCounter.delegate = self;
    
    //血條公式
    _heroBlood.lostPerAttack = _bossBlood.lostPerAttack = 100/([_qaArr count]/2 +1) +1;
    
    [_heroBlood initialize];
    [_bossBlood initialize];
}

-(void)initVariable{
    totalQuestion = [_qaArr count];
    currentQuestion = 0;
    
    currentAnswerArr = [[NSMutableArray alloc]init];
    
    isGameEnd = NO;
}

-(void)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark Blood CallBack
-(void)devilWin{
    NSLog(@"你輸了");
    [self stopEverything];
    
    _quView.hidden = YES;
    _winloseView.hidden = NO;
    
    _statusImg1.image = [UIImage imageNamed:@"fight_lose_icon"];
    _statusImg2.image = [UIImage imageNamed:@"fight_lose_text"];
    _statusLabel.text = _totalLabel.text;
    _statusLabel.textColor = [UIColor redColor];
    
}

-(void)humanWin{
    NSLog(@"你贏了");
    [self stopEverything];
    
    _quView.hidden = YES;
    _winloseView.hidden = NO;
    
    _statusImg1.image = [UIImage imageNamed:@"fight_win_icon"];
    _statusImg2.image = [UIImage imageNamed:@"fight_win_text"];
    _statusLabel.text = _totalLabel.text;
    _statusLabel.textColor = [UIColor blueColor];
}


-(void)stopEverything{
    [_timeCounter stop];
    [totalTimer invalidate];
    isGameEnd = YES;
}

-(void)timeisEnd{
    [_heroBlood getAttack];
    [self gotoNextQuestion];
}

- (IBAction)clickAnswer:(UIButton*)btn {
    NSLog(@"tag = %d,correctTag = %d",btn.tag,correctAnswerIndex);
    
    if (btn.tag == correctAnswerIndex) {
        [self AnswerCorrect];
    }
    else{
        [self AnswerWrong:btn.tag];
    }
}

-(void)AnswerCorrect{
    //答對了
    [_bossBlood getAttack];
    [_timeCounter stop];
    
    [self showRightAnswer];
    
    [self performSelector:@selector(gotoNextQuestion) withObject:nil afterDelay:2.0f];
}

-(void)AnswerWrong:(NSInteger)tag{
    //答錯了
    [_heroBlood getAttack];
    [_timeCounter stop];
    
    [self showRightAnswer];
    [self showWrongAnswer:tag];
    
    [self performSelector:@selector(gotoNextQuestion) withObject:nil afterDelay:2.0f];
}

-(void)showRightAnswer{
    UIButton *correctBtn = (UIButton*)[_choiceView viewWithTag:correctAnswerIndex];
    [correctBtn setBackgroundImage:[UIImage imageNamed:@"fight_correct_btn"] forState:UIControlStateNormal];
}

-(void)showWrongAnswer:(NSInteger)tag{
    UIButton *correctBtn = (UIButton*)[_choiceView viewWithTag:tag];
    [correctBtn setBackgroundImage:[UIImage imageNamed:@"fight_wrong_btn"] forState:UIControlStateNormal];
}
@end
