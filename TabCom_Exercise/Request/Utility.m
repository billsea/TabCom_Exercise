//
//  utility.m
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import "Expense+CoreDataClass.h"

@implementation Utility
+ (NSMutableArray* )dataForEntity:(NSString*)entityString andSortKey:(NSString*)key {
	AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = app.persistentContainer.viewContext;
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityString];
	
	if(![key isEqualToString:@""]) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];
	}
	
	NSMutableArray* data = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
	return data;
}
@end
