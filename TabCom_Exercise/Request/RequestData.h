//
//  RequestData.h
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestData : NSObject
@property void (^callback)(bool);
- (void)requestDataWithResource:(NSString*)resourceName;
@end
