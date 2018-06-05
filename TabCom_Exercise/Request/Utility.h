//
//  utility.h
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+ (NSMutableArray* )dataForEntity:(NSString*)entityString andSortKey:(NSString*)key;
+ (void)deleteAllObjectsForEntity:(NSString *)entityString;
+ (NSString *)formatNumber:(NSNumber *)number;
@end
