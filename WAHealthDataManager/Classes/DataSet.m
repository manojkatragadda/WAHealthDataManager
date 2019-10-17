//
//  DataSet.m
//  WAHealthDataFetcher
//
//  Created by Manoj Katragadda on 15/10/19.
//  Copyright © 2019 Manoj. All rights reserved.
//

#import "DataSet.h"

@implementation DataSet

-(NSDictionary *) dictionaryData {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSString stringWithFormat:@"%.0f",self.startTimeInterval] forKey:@"startTimeNanos"];
    [dictionary setValue: [NSString stringWithFormat:@"%.0f",self.endTimeInterval] forKey:@"endTimeNanos"];
    [dictionary setObject:@[@{@"intVal": [NSNumber numberWithInt:self.cummilativeVal],
                             @"fpVal": [NSNumber numberWithDouble:self.cummilativeFpVal]
    }] forKey:@"value"];
    return dictionary;
}
@end
