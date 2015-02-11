//
//  GuluViewController.m
//  Gulu
//
//  Created by 武村 達也 on 13/02/26.
//  Copyright (c) 2013年 武村 達也. All rights reserved.
//

#import "GuluViewController.h"

@interface GuluViewController ()
//@interface EndingViewController ()

@end

@implementation GuluViewController


- (void)viewDidLoad
{
    
    //int checkPoint = 0;
    //_numberLabel.text = [NSString stringWithFormat:@"%d", checkPoint];

    // str = @"6,15,18,13,6";
    str = @"10,16,22,12,10";
    
    check = [str componentsSeparatedByString:@","];
    
    _startLabel.text = [NSString stringWithFormat:@"START"];
 
    [super viewDidLoad];
    
}


- (void) timeCount:(NSTimer*)timer{
    
    float fltMsec = floor(([[[NSDate alloc]init]timeIntervalSince1970]
                           - floor([startDate timeIntervalSince1970]))*10);
    
    float s1 = 200 - fltMsec ;
    
    float s = s1 / 10;
    
    // gameover
    if (s <= 0){
        
        [timer invalidate];
        
        
        _timeupLabel.text = [NSString stringWithFormat:@"TIME UP!"];
        
        _startLabel.text = [NSString stringWithFormat:@"REPLAY"];

        checkPoint = 0;
        score=0;
        
                    
        }
    
    _timeLabel.text = [NSString stringWithFormat:@"%2.1f",s];
 
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // ユーザがドラッグした座標を取得
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    
    int x0 = (int)round(pos.x * 0.012) ;
    int y0 = (int)round(pos.y * 0.012) ;
    
     _checkPointnumberLabel.text = [NSString stringWithFormat:@"%d:%d", x0 ,y0];
    
    int xy = x0 + y0 *4;

    int xycheck= [[check objectAtIndex: checkPoint]intValue];
    
    if (xy == xycheck ){
        
        checkPoint = 1;
        
        
        _numberLabel.text = [NSString stringWithFormat:@"%d", checkPoint];
        
        _scoreLabel.text = [NSString stringWithFormat:@"%02d", score];
        
        _timeupLabel.text = [NSString stringWithFormat:@""];
        
        _startLabel.text = [NSString stringWithFormat:@""];
        
        tm = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timeCount:) userInfo:nil repeats:YES ];
        
        //_timeLabel.text = [NSString stringWithFormat:@"%02d",30];
        

        startDate = [NSDate date];

        
    }
    
    
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    int s = [ _timeLabel.text intValue ];
    if (s != 0)
    {

    
    // ユーザがドラッグした座標を取得
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    
    int x0 = (int)round(pos.x * 0.012) ;
    int y0 = (int)round(pos.y * 0.012) ;
    
    _checkPointnumberLabel.text = [NSString stringWithFormat:@"%d:%d", x0 ,y0];
    
    int xy = x0 + y0 *4;
    
    int xycheck= [[check objectAtIndex: checkPoint]intValue];
    
    if (xy == xycheck ){
        
                    checkPoint = checkPoint + 1;
        
        
        
        _numberLabel.text = [NSString stringWithFormat:@"%d", checkPoint];

        
        if (checkPoint == 5 ){
            checkPoint=1;
            score = score + 1;
            _scoreLabel.text = [NSString stringWithFormat:@"%02d", score];
            
        }
        _numberLabel.text = [NSString stringWithFormat:@"%d", checkPoint];
        
           }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
}

@end
