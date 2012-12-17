//
//  ViewController.m
//  logMagandAccel
//
//  Created by Robert Ritchie on 11/24/12.
//  Copyright (c) 2012 Robert Ritchie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation ViewController

@synthesize xLabel, yLabel, zLabel;
@synthesize motionManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    testRunning = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"ViewWillDisappear");
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.motionManager stopGyroUpdates];

}

- (IBAction)startPressed:(UIButton *)sender {
    self.xLabel.text = @"Y";
    self.yLabel.text = @"E";
    self.zLabel.text = @"S";
    
    if (!testRunning) {
        
        
        CMMotionManager *manager = [[CMMotionManager alloc] init];
        self.motionManager = manager;
        
        
        self.motionManager.gyroUpdateInterval = 0.02;
        self.motionManager.accelerometerUpdateInterval = 0.02;
        self.motionManager.magnetometerUpdateInterval = 0.02;
        //self.motionManager.deviceMotionUpdateInterval = 0.15;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docs_dir = [paths objectAtIndex:0];
        
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        
        [outputFormatter setDateFormat:@"HH_mm_SS-MM_d"];
        NSDate *date = [[NSDate alloc] init];
        NSString *newDateString = [outputFormatter stringFromDate:date];
        NSLog(@"newDateString %@", newDateString);
        
        NSString *file = [NSString stringWithFormat:@"%@/%@%@",docs_dir,newDateString,@"gyro.txt"];
        const char *cDocumentPath = [file cStringUsingEncoding:NSUTF8StringEncoding];
        filePointGyro = fopen(cDocumentPath, "a");
        
        file = [NSString stringWithFormat:@"%@/%@%@",docs_dir,newDateString,@"accel.txt"];
        cDocumentPath = [file cStringUsingEncoding:NSUTF8StringEncoding];
        filePointAccel = fopen(cDocumentPath, "a");
        
        file = [NSString stringWithFormat:@"%@/%@%@",docs_dir,newDateString,@"mag.txt"];
        cDocumentPath = [file cStringUsingEncoding:NSUTF8StringEncoding];
        filePointMag = fopen(cDocumentPath, "a");
        
        file = [NSString stringWithFormat:@"%@/%@%@",docs_dir,newDateString,@"attitude.txt"];
        cDocumentPath = [file cStringUsingEncoding:NSUTF8StringEncoding];
        filePointAtt = fopen(cDocumentPath, "a");
        
        [self.motionManager startGyroUpdatesToQueue:[[NSOperationQueue alloc] init]
                                        withHandler:^(CMGyroData *data, NSError *error) {
                                            fprintf(filePointGyro, "%f\t%f\t%f\t%f\n",data.rotationRate.x,data.rotationRate.y,data.rotationRate.z,data.timestamp);
//                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                                xLabel.text = [NSString stringWithFormat:@"%f", data.rotationRate.x];
//                                                yLabel.text = [NSString stringWithFormat:@"%f", data.rotationRate.y];
//                                                zLabel.text = [NSString stringWithFormat:@"%f", data.rotationRate.z];
//                                                
//                                            });
                                            
                                        }];
        
        [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            fprintf(filePointAccel, "%f\t%f\t%f\t%f\n",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z,accelerometerData.timestamp);
            
        }];
        NSOperationQueue *opQueue3 = [[NSOperationQueue alloc] init];
        
        [self.motionManager startMagnetometerUpdatesToQueue:opQueue3 withHandler:^(CMMagnetometerData *magnetometerData, NSError *error){
            
            fprintf(filePointMag, "%f\t%f\t%f\t%f\n",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z,magnetometerData.timestamp);
        }];
        
//            [self.motionManager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion,NSError *error){
//                
//                
//                fprintf(filePointAtt, "%f\t%f\t%f\t%f\t\n",motion.attitude.roll,motion.attitude.pitch,motion.attitude.yaw,motion.timestamp);
////                             dispatch_async(dispatch_get_main_queue(), ^{
////                                          xLabel.text = [NSString stringWithFormat:@"%f", motion.attitude.roll];
////                                          yLabel.text = [NSString stringWithFormat:@"%f", motion.attitude.pitch];
////                                          zLabel.text = [NSString stringWithFormat:@"%f", motion.attitude.yaw];
////                
////                                                    });
//
//          
//            }];
        testRunning = YES;
    }
    

}

- (IBAction)deletePressed:(UIButton *)sender {
    
#define kDOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *en = [fileManager enumeratorAtPath:kDOCSFOLDER];
    NSString *fileEn;
    while (fileEn = [en nextObject]) {
        NSLog(@"File To Delete : %@",fileEn);
        
        NSLog(@"yup");
        NSError *error;
        [fileManager removeItemAtPath:[kDOCSFOLDER stringByAppendingPathComponent:fileEn] error:&error];
        NSLog([error description]);
        
    }
    
}

- (IBAction)stopPressed:(UIButton *)sender {
    
    self.xLabel.text = @"S";
    self.yLabel.text = @"T";
    self.zLabel.text = @"P";
    
    [self.motionManager stopGyroUpdates];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopDeviceMotionUpdates];
    fclose(filePointGyro);
    fclose(filePointAccel);
    fclose(filePointMag);
    fclose(filePointAtt);
    testRunning = NO;
    
}
@end
