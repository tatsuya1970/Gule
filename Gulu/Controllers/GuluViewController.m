//
//  GuluViewController.m
//  Gulu
//
//  Created by 武村 達也 on 13/02/26.
//  Copyright (c) 2013年 武村 達也. All rights reserved.
//

#import "GuluViewController.h"
#import "AVFoundation/AVAudioPlayer.h"

@interface GuluViewController ()

@property (strong, nonatomic) UIView *flashView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *backgroundPlayer;
@property (strong, nonatomic) AVAudioPlayer *timeUpMusic;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fireballImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLabelCenterYAligmentConstraint;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeupLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) NSURL *boomSoundUrl;
@property (strong, nonatomic) NSURL *timeUpSoundUrl;


@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat widthError;
@property (nonatomic) CGFloat circleLineWidth;

@end

@implementation GuluViewController

#pragma mark - Lyfecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.widthError = 30;
    self.circleLineWidth = 20;
    self.radius = self.view.bounds.size.width / 2 - 20;

    self.fireballImage.translatesAutoresizingMaskIntoConstraints = YES;

    [UIApplication sharedApplication].statusBarHidden = YES;
    //int checkPoint = 0;

    self.flashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.flashView.backgroundColor = [UIColor whiteColor];
    self.flashView.alpha = 0;

    NSMutableArray *images = [@[] mutableCopy];
    for (int i = 2; i < 22; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"star-%d", i]]];
    }

    self.fireballImage.animationImages = [images copy];
    self.fireballImage.animationDuration = 1.5;

    [self drawUI];

    self.fireballImage.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2 - self.radius);
    self.startLabelCenterYAligmentConstraint.constant = self.radius + 40;

    [self.view addSubview:self.flashView];

    self.boomSoundUrl = [[NSBundle mainBundle] URLForResource:@"boom" withExtension:@"mp3"];
    self.timeUpSoundUrl = [[NSBundle mainBundle] URLForResource:@"timeup" withExtension:@"mp3"];
    NSURL *backgroundMusicUrl = [[NSBundle mainBundle] URLForResource:@"bgm" withExtension:@"mp3"];

    self.audioPlayer = [self audioPlayerWithUrl:self.boomSoundUrl];
    self.audioPlayer.rate = 2;
    self.audioPlayer.enableRate = YES;

    self.timeUpMusic = [self audioPlayerWithUrl:self.timeUpSoundUrl];

    self.backgroundPlayer = [self audioPlayerWithUrl:backgroundMusicUrl];
    self.backgroundPlayer.numberOfLoops = -1;

    [self calcPoints];

    self.startLabel.text = [NSString stringWithFormat:@"START"];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [UIView animateWithDuration:15.0f delay:0.0f options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - CGRectGetWidth(self.view.frame), 0)];

    }completion:nil];
}

#pragma mark - Private

- (AVAudioPlayer *)audioPlayerWithUrl:(NSURL *)url {
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [audioPlayer prepareToPlay];

    return audioPlayer;
}

- (void)calcPoints {
    CGFloat radians = - M_PI_2;
    CGPoint arcPoint;
    NSMutableArray *points = [@[] mutableCopy];
    for (int i = 1; i <= 5; i++) {
        arcPoint = [self getArcPointFromAngle:radians];
        [points addObject:[NSValue value:&arcPoint withObjCType:@encode(CGPoint)]];
        radians += M_PI_2;
    }
    check = [points copy];
}

- (BOOL)checkPoint:(CGPoint)point index:(NSInteger)index {
    CGPoint checkPoint = [check[index] CGPointValue];
    CGRect rect = CGRectMake(checkPoint.x - self.widthError / 2, checkPoint.y - self.widthError / 2, self.widthError, self.widthError);

    return CGRectContainsPoint(rect, point);
}

- (void)drawUI {
    CGPoint circlePosition = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.view.bounds) / 2);

    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [[UIScreen mainScreen] scale]);

    [self.backgroundImageView.image drawInRect:self.view.frame];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, self.circleLineWidth);
    CGContextAddArc(context, circlePosition.x, circlePosition.y , self.radius, 0, 2 * M_PI, 1);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddArc(context, circlePosition.x, circlePosition.y - self.radius, 10, 0, M_PI * 2, 1);
    CGContextDrawPath(context, kCGPathFill);

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    self.backgroundImageView.image = result;
}

- (CGPoint)getArcPointFromAngle:(CGFloat)angle {
    CGFloat x = self.radius * cosf(angle) + self.view.center.x;
    CGFloat y = self.radius * sinf(angle) + self.view.center.y;

    return CGPointMake(x, y);
}

- (CGFloat)getAngleFromPoint:(CGPoint)point {
    CGFloat result = 0;
    CGFloat deltaX, deltaY;
    deltaX = point.x - self.view.center.x;
    deltaY = - self.view.center.y + point.y;

    if (deltaX == 0) {
        result  = deltaY > 0 ? M_PI_2 : - M_PI_2;
    } else {
        result = deltaX > 0 ? 0 : M_PI;
    }

    if (deltaX != 0) {
        result += atanf(deltaY / deltaX);
    }

    return result;
}

- (void)flash {
    [self.flashView setAlpha:1.0f];

    [UIView beginAnimations:@"flash screen" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

    [self.flashView setAlpha:0.0f];

    [UIView commitAnimations];
}

- (void) timeCount:(NSTimer*)timer {
    float fltMsec = floor(([[[NSDate alloc]init]timeIntervalSince1970] - floor([startDate timeIntervalSince1970])) * 10);
    float s1 = 300 - fltMsec ;
    float s = s1 / 10;
    // gameover
    if (s <= 0){
        [timer invalidate];

        self.timeupLabel.text = [NSString stringWithFormat:@"TIME UP!"];
        self.startLabel.text = [NSString stringWithFormat:@"REPLAY"];
        checkPoint = 0;
        score = 0;

        [self.backgroundPlayer stop];
        [self.timeUpMusic play];

        CGPoint arcPoint = [self getArcPointFromAngle:-M_PI_2];

        self.fireballImage.center = arcPoint;
        self.fireballImage.transform = CGAffineTransformMakeRotation(-M_PI_2 + ( M_PI / 3));
    }

    self.timeLabel.text = [NSString stringWithFormat:@"%2.1f", s];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.titleImageView.hidden) {
        [UIView animateWithDuration:0.7 animations:^{
            self.titleImageView.alpha = 0;
        } completion:^(BOOL finished) {
            self.titleImageView.hidden = YES;
        } ];

        return;
    }
    CGPoint pos = [[touches anyObject] locationInView:self.view];

    if ([self checkPoint:pos index:checkPoint]) {
        checkPoint = 1;

        self.numberLabel.text = [NSString stringWithFormat:@"%d", checkPoint];
        self.scoreLabel.text = [NSString stringWithFormat:@"%02d", score];
        self.timeupLabel.text = [NSString stringWithFormat:@""];
        self.startLabel.text = [NSString stringWithFormat:@""];

        [self.fireballImage startAnimating];
        [self.backgroundPlayer play];

        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timeCount:) userInfo:nil repeats:YES ];

        startDate = [NSDate date];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    float s = [self.timeLabel.text floatValue];
    if (s != 0) {
        CGPoint pos = [[touches anyObject] locationInView:self.view];
        CGFloat radians = [self getAngleFromPoint:pos];

        CGPoint arcPoint = [self getArcPointFromAngle:radians];

        self.fireballImage.center = arcPoint;
        self.fireballImage.transform = CGAffineTransformMakeRotation(radians + ( M_PI / 3));

        if ([self checkPoint:pos index:checkPoint]) {
            checkPoint += 1;

            if (checkPoint == 5) {
                [self flash];

                if (self.audioPlayer.isPlaying) {
                    [self.audioPlayer stop];
                }

                [self.audioPlayer play];

                checkPoint = 1;
                score += 1;
                self.scoreLabel.text = [NSString stringWithFormat:@"%02d", score];
            }

            self.numberLabel.text = [NSString stringWithFormat:@"%d", checkPoint];
        }
    }
}

@end
