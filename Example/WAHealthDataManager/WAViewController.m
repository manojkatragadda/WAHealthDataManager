//
//  WAViewController.m
//  WAHealthDataManager
//
//  Created by Manoj Katragadda on 10/17/2019.
//  Copyright (c) 2019 Manoj Katragadda. All rights reserved.
//

#import "WAViewController.h"
@import WAHealthDataManager;
@interface WAViewController ()

@end

@implementation WAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    WAHealthDataManager *manager = [WAHealthDataManager shared];
    NSDate *lastdate = [NSDate dateWithTimeIntervalSinceNow:-2*24*60*60];
    [manager getHealthDataSince:lastdate withCompletionHandler:^(NSDictionary * _Nonnull responseDict, NSError * _Nonnull err) {
        NSLog(@"Data from health kit is : %@", responseDict);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
