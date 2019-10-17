//
//  DataSet.h
//  WAHealthDataFetcher
//
//  Created by Manoj Katragadda on 15/10/19.
//  Copyright © 2019 Manoj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataSet : NSObject
@property (nonatomic) NSTimeInterval startTimeInterval;
@property (nonatomic) NSTimeInterval endTimeInterval;
@property (nonatomic) double cummilativeVal;
@property (nonatomic) double cummilativeFpVal;
-(NSDictionary *) dictionaryData;
@end

NS_ASSUME_NONNULL_END
