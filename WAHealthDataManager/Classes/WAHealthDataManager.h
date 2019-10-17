//
//  WAHealthDataManager.h
//  WAHealthDataFetcher
//
//  Created by Manoj Katragadda on 15/10/19.
//  Copyright © 2019 Manoj. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HealthKit;
NS_ASSUME_NONNULL_BEGIN

@interface WAHealthDataManager : NSObject

@property (nonatomic, strong) NSSet *allDataSet;
+ (WAHealthDataManager *)shared;
-(void) getHealthDataSince:(NSDate *) date withCompletionHandler:(void (^)(NSDictionary *responseDict, NSError *err))completionHandler;
@end
NS_ASSUME_NONNULL_END
