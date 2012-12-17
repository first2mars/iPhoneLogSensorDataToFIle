//
//  ViewController.h
//  logMagandAccel
//
//  Created by Robert Ritchie on 11/24/12.
//  Copyright (c) 2012 Robert Ritchie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@interface ViewController : UIViewController{
    
    FILE *filePointGyro;
    FILE *filePointAccel;
    FILE *filePointMag;
    FILE *filePointAtt;
    BOOL testRunning;
    
    CMMotionManager *motionManager;

}

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

- (IBAction)startPressed:(UIButton *)sender;
- (IBAction)deletePressed:(UIButton *)sender;
- (IBAction)stopPressed:(UIButton *)sender;


@end
