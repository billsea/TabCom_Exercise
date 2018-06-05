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

+ (void)deleteAllObjectsForEntity:(NSString *)entityString
{
	AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = app.persistentContainer.viewContext;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityString];
	[fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
	NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (NSManagedObject *object in fetchedObjects)
	{
		[context deleteObject:object];
	}
	
	error = nil;
	[context save:&error];
}
@end
