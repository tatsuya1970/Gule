//
//  GuluViewController.h
//  Gulu
//
//  Created by 武村 達也 on 13/02/26.
//  Copyright (c) 2013年 武村 達也. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuluViewController : UIViewController

{
    NSString *str ;
	NSArray *check;
    NSDate *startDate ;
    NSTimer *tm;
    
    int checkPoint, score;
    
}

@property (strong, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic) IBOutlet UILabel *checkPointnumberLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeupLabel;

@property (strong, nonatomic) IBOutlet UILabel *startLabel;

@end
