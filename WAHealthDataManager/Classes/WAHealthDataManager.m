//
//  WAHealthDataManager.m
//  WAHealthDataFetcher
//
//  Created by Manoj Katragadda on 15/10/19.
//  Copyright © 2019 Manoj. All rights reserved.
//

#import "WAHealthDataManager.h"
#import "DataSet.h"

@interface WAHealthDataManager ()
@property (nonatomic, strong) HKHealthStore *healthStore;
@end


@implementation WAHealthDataManager
- (id)init{
    self = [super init];
    self.allDataSet = [self defaultAllDataSet];
    self.healthStore = [[HKHealthStore alloc] init];
    return self;
}
+ (WAHealthDataManager *)shared
{
    __strong static WAHealthDataManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
-(void) getHealthDataSince:(NSDate *) date withCompletionHandler:(void (^)(NSDictionary *responseDict, NSError *err))completionHandler {
    if ([self isHealthKitAvailable]) {
        [self.healthStore requestAuthorizationToShareTypes:nil readTypes:self.allDataSet completion:^(BOOL success, NSError * _Nullable error) {
            if(error) {
                completionHandler(nil, error);
                return;
            }
                [self getDataSinceDate:date WithCompletionHandler:^(NSDictionary *responseDict, NSError *err) {
                    completionHandler(responseDict, error);
                }];
        }];
    } else {
        NSMutableDictionary* errInfo = [NSMutableDictionary dictionary];
        [errInfo setValue:@"HealthKit not Available" forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:@"HealthDataErr" code:5001 userInfo:errInfo];
        completionHandler(nil, err);
        return;
    }
}
-(void) getDataSinceDate:(NSDate *) sinceDate WithCompletionHandler:(void (^)(NSDictionary *responseDict, NSError *err))completionHandler {

    __block NSError *accumError = nil;
    __block NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:6];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    // Step Count
    [self getStepCountDataSince:sinceDate WithCompletionHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable statsCollection, NSError * _Nullable error) {
        NSMutableArray *resultArray = [NSMutableArray array];
        if (error) {
            accumError = error;
        } else if (statsCollection != nil) {
            NSDate *endDate = [NSDate date];
            [statsCollection enumerateStatisticsFromDate:sinceDate toDate:endDate withBlock:^(HKStatistics * _Nonnull stat, BOOL * _Nonnull stop) {
                if (stat.sumQuantity) {
                    DataSet *newSet = [[DataSet alloc] init];
                    newSet.startTimeInterval = stat.startDate.timeIntervalSince1970 * 1000;
                    newSet.endTimeInterval = stat.endDate.timeIntervalSince1970 * 1000;
                    newSet.cummilativeVal = (int)[stat.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
                    newSet.cummilativeFpVal = [stat.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
                    [resultArray addObject:[newSet dictionaryData]];
                }
            }];
            [resultDict setObject:resultArray forKey:@"step_count"];
        }
        
        dispatch_group_leave(group);
    }];
    // Heart Rate : heart_rate
    dispatch_group_enter(group);
    [self getHeartRateDataSince:sinceDate WithCompletionHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable statsCollection, NSError * _Nullable error) {
        NSMutableArray *resultArray = [NSMutableArray array];
        if (error) {
            accumError = error;
        } else if (statsCollection != nil) {
            NSDate *endDate = [NSDate date];
            [statsCollection enumerateStatisticsFromDate:sinceDate toDate:endDate withBlock:^(HKStatistics * _Nonnull stat, BOOL * _Nonnull stop) {
                if (stat.averageQuantity) {
                    DataSet *newSet = [[DataSet alloc] init];
                    newSet.startTimeInterval = stat.startDate.timeIntervalSince1970 * 1000;
                    newSet.endTimeInterval = stat.endDate.timeIntervalSince1970 * 1000;
                    newSet.cummilativeVal = (int)[stat.averageQuantity doubleValueForUnit:[HKUnit unitFromString:@"count/min"]];
                    newSet.cummilativeFpVal = [stat.averageQuantity doubleValueForUnit:[HKUnit unitFromString:@"count/min"]];

                    [resultArray addObject:[newSet dictionaryData]];
                }
            }];
            [resultDict setObject:resultArray forKey:@"heart_rate"];
        }
        
        dispatch_group_leave(group);
    }];
    
    // Energy Spent: calories_expended
    dispatch_group_enter(group);
    [self getEnergySpentDataSince:sinceDate WithCompletionHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable statsCollection, NSError * _Nullable error) {
        NSMutableArray *resultArray = [NSMutableArray array];
        if (error) {
            accumError = error;
        } else if (statsCollection != nil) {
            NSDate *endDate = [NSDate date];
            [statsCollection enumerateStatisticsFromDate:sinceDate toDate:endDate withBlock:^(HKStatistics * _Nonnull stat, BOOL * _Nonnull stop) {
                if (stat.sumQuantity) {
                    DataSet *newSet = [[DataSet alloc] init];
                    newSet.startTimeInterval = stat.startDate.timeIntervalSince1970 * 1000;
                    newSet.endTimeInterval = stat.endDate.timeIntervalSince1970 * 1000;
                    newSet.cummilativeVal = (int)[stat.sumQuantity doubleValueForUnit:[HKUnit kilocalorieUnit]];
                    newSet.cummilativeFpVal = [stat.sumQuantity doubleValueForUnit:[HKUnit kilocalorieUnit]];

                    [resultArray addObject:[newSet dictionaryData]];
                }
            }];
            [resultDict setObject:resultArray forKey:@"calories_expended"];
        }
        
        dispatch_group_leave(group);
    }];
    // Apple excersie : active_minutes
    dispatch_group_enter(group);
    [self getExerciseMinutesDataSince:sinceDate WithCompletionHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable statsCollection, NSError * _Nullable error) {
        NSMutableArray *resultArray = [NSMutableArray array];
        if (error) {
            accumError = error;
        } else if (statsCollection != nil) {
            NSDate *endDate = [NSDate date];
            [statsCollection enumerateStatisticsFromDate:sinceDate toDate:endDate withBlock:^(HKStatistics * _Nonnull stat, BOOL * _Nonnull stop) {
                if (stat.sumQuantity) {
                    DataSet *newSet = [[DataSet alloc] init];
                    newSet.startTimeInterval = stat.startDate.timeIntervalSince1970 * 1000;
                    newSet.endTimeInterval = stat.endDate.timeIntervalSince1970 * 1000;
                    newSet.cummilativeVal = (int)[stat.sumQuantity doubleValueForUnit:[HKUnit minuteUnit]];
                    newSet.cummilativeFpVal = [stat.sumQuantity doubleValueForUnit:[HKUnit minuteUnit]];
                    [resultArray addObject:[newSet dictionaryData]];
                }
            }];
            [resultDict setObject:resultArray forKey:@"active_minutes"];
        }
        
        dispatch_group_leave(group);
    }];
    
    // Total Distance Travelled: distance
    dispatch_group_enter(group);
    [self getDistanceTraveledWalkingSince:sinceDate WithCompletionHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable statsCollection, NSError * _Nullable error) {
        NSMutableArray *resultArray = [NSMutableArray array];
        if (error) {
            accumError = error;
        } else if (statsCollection != nil) {
            NSDate *endDate = [NSDate date];
            [statsCollection enumerateStatisticsFromDate:sinceDate toDate:endDate withBlock:^(HKStatistics * _Nonnull stat, BOOL * _Nonnull stop) {
                if (stat.sumQuantity) {
                    DataSet *newSet = [[DataSet alloc] init];
                    newSet.startTimeInterval = stat.startDate.timeIntervalSince1970 * 1000;
                    newSet.endTimeInterval = stat.endDate.timeIntervalSince1970 * 10000;
                    newSet.cummilativeVal = (int)[stat.sumQuantity doubleValueForUnit:[HKUnit meterUnit]];
                    newSet.cummilativeFpVal = [stat.sumQuantity doubleValueForUnit:[HKUnit meterUnit]];
                    [resultArray addObject:[newSet dictionaryData]];
                }
            }];
            [resultDict setObject:resultArray forKey:@"distance"];
        }
        
        dispatch_group_leave(group);
    }];
    
    // When all the groups are completed. Notify should start
    dispatch_group_notify(group, dispatch_get_main_queue(),^{
        if(accumError != nil) {
            completionHandler(nil,accumError);
        } else {
            completionHandler(resultDict, nil);
        }
    });
}
-(void) getStepCountDataSince:(NSDate *) sinceDate WithCompletionHandler:(void (^)(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error)) completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        HKStatisticsOptions sumOption = HKStatisticsOptionCumulativeSum;
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.hour = 1; //every hour
        HKStatisticsCollectionQuery *queryObj = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount] quantitySamplePredicate:nil options:sumOption anchorDate:sinceDate intervalComponents:interval];
        [queryObj setInitialResultsHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(query,result,error);
            });
        }];
        [self.healthStore executeQuery:queryObj];
    });
    
}
-(void) getHeartRateDataSince:(NSDate *) sinceDate WithCompletionHandler:(void (^)(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error)) completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        HKStatisticsOptions statOption = HKStatisticsOptionDiscreteAverage;
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.hour = 1; //every hour
        HKStatisticsCollectionQuery *queryObj = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate] quantitySamplePredicate:nil options:statOption anchorDate:sinceDate intervalComponents:interval];
        [queryObj setInitialResultsHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(query,result,error);
            });
        }];
        [self.healthStore executeQuery:queryObj];
    });
    
}
-(void) getEnergySpentDataSince:(NSDate *) sinceDate WithCompletionHandler:(void (^)(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error)) completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        HKStatisticsOptions statOption = HKStatisticsOptionCumulativeSum;
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.hour = 1; //every hour
        HKStatisticsCollectionQuery *queryObj = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] quantitySamplePredicate:nil options:statOption anchorDate:sinceDate intervalComponents:interval];
        [queryObj setInitialResultsHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(query,result,error);
            });
        }];
        [self.healthStore executeQuery:queryObj];
    });
    
}
-(void) getExerciseMinutesDataSince:(NSDate *) sinceDate WithCompletionHandler:(void (^)(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error)) completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        HKStatisticsOptions statOption = HKStatisticsOptionCumulativeSum;
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.hour = 1; //every hour
        HKStatisticsCollectionQuery *queryObj = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierAppleExerciseTime] quantitySamplePredicate:nil options:statOption anchorDate:sinceDate intervalComponents:interval];
        [queryObj setInitialResultsHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(query,result,error);
            });
        }];
        [self.healthStore executeQuery:queryObj];
    });
    
}
-(void) getDistanceTraveledWalkingSince:(NSDate *) sinceDate WithCompletionHandler:(void (^)(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error)) completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        HKStatisticsOptions statOption = HKStatisticsOptionCumulativeSum;
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.hour = 1; //every hour
        HKStatisticsCollectionQuery *queryObj = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning] quantitySamplePredicate:nil options:statOption anchorDate:sinceDate intervalComponents:interval];
        [queryObj setInitialResultsHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(query,result,error);
            });
        }];
        [self.healthStore executeQuery:queryObj];
    });
    
}
-(void) getDistanceTraveledCyclingSince:(NSDate *) sinceDate WithCompletionHandler:(void (^)(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error)) completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        HKStatisticsOptions statOption = HKStatisticsOptionCumulativeSum;
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.hour = 1; //every hour
        HKStatisticsCollectionQuery *queryObj = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling] quantitySamplePredicate:nil options:statOption anchorDate:sinceDate intervalComponents:interval];
        [queryObj setInitialResultsHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(query,result,error);
            });
        }];
        [self.healthStore executeQuery:queryObj];
    });
    
}



-(BOOL) isHealthKitAvailable {
    return HKHealthStore.isHealthDataAvailable;
}
-(NSSet *) defaultAllDataSet {
    if ([self isHealthKitAvailable]) {
        NSSet *allDataSet = [NSSet setWithObjects:[HKObjectType workoutType],
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                             [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierActiveEnergyBurned],
                             [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierAppleExerciseTime],
                             [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceWalkingRunning],
                             [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceWheelchair],
                             [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceSwimming],
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                             nil];
        return allDataSet;
    }
    return [NSSet set];
}
-(void) checkForAuthorizationWithCompletion:(void (^)(BOOL authorized, NSError *err)) completionHandler {
    
//        healthStore.requestAuthorization(toShare: HealthDataManager.allDataSet, read: HealthDataManager.allDataSet) { (completed, err) in
//            if let error = err {
////                self.showAlert(error.localizedDescription);
//            } else {
//                // got permession to get the results.
//                self.getData();
//            }
    
}
@end
