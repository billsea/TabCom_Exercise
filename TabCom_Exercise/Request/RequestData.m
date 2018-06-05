//
//  RequestData.m
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import "RequestData.h"
#import "Global.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "Utility.h"
#import "Expense_Items+CoreDataClass.h"
#import "Expense+CoreDataClass.h"

@implementation RequestData

- (void)requestDataWithResource:(NSString*)resourceName {
	NSString* urlString = [NSString stringWithFormat:@"%@%@?format=json", BaseURLString, resourceName];
	NSURL* dataUrl = [NSURL URLWithString:urlString];
	
	NSURLSessionConfiguration* requestConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
	AFURLSessionManager* requestManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:requestConfig];
	NSURLRequest* urlRequest = [NSURLRequest requestWithURL:dataUrl];
	
	//TODO : Log download progress
	NSURLSessionDataTask* dataRequestTask = [requestManager dataTaskWithRequest:urlRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		if (error) {
			NSLog(@"Error: %@", error);
		} else {
			NSLog(@"%@ %@", response, responseObject);
			[self parseResponse:responseObject];
		}
	}];
	[dataRequestTask resume];
}

- (id)updateDataTypeWithValue:(id)value andAttributes:(NSDictionary*)attributes andAttribute:(NSString*)attribute {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
	if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
		value = [value stringValue];
	} else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
		value = [NSNumber numberWithInteger:[value integerValue]];
	} else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
		value = [NSNumber numberWithDouble:[value doubleValue]];
	} else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
		value = [dateFormatter dateFromString:value];
	}
	
	return value;
}
- (void)parseResponse:(id)responseObject {
		AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		NSManagedObjectContext* context = app.persistentContainer.viewContext;
		NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:context];

		NSEntityDescription* entityDescItems = [NSEntityDescription entityForName:@"Expense_Items" inManagedObjectContext:context];
		NSDictionary *attributesItems = [entityDescItems attributesByName];
	
		//get attributes(names) from data model
		NSDictionary *attributes = [entityDesc attributesByName];
		NSArray* items = (NSArray*)responseObject;

		//Loop through results, and map to data model
		for(NSDictionary* item in items) {
			
			//Create new Expense object ..TODO: existing or new?
			NSManagedObject* expenseObject = [NSEntityDescription insertNewObjectForEntityForName:entityDesc.name inManagedObjectContext:context];
			Expense* expense = (Expense*)expenseObject;
			
			for (NSString *attribute in attributes) {
				id value = [item objectForKey:attribute];
				if (value == nil) {
					continue;
				}
				//set value
				[expenseObject setValue:[self updateDataTypeWithValue:value andAttributes:attributes andAttribute:attribute] forKey:attribute];
				
				//Add expense items
				NSManagedObject* itemObject = [NSEntityDescription insertNewObjectForEntityForName:@"Expense_Items" inManagedObjectContext:context];
				Expense_Items* newExpenseItem = (Expense_Items*)itemObject;
				
				NSDictionary* expenseDetailItems = [item objectForKey:@"items"]; //TODO: this could be better
				for(NSDictionary* itm in expenseDetailItems){
					for (NSString *attributeItem in attributesItems) {
						id value2 = [itm objectForKey:attributeItem];
						if (value2 == nil) {
							continue;
						}
						[itemObject setValue:[self updateDataTypeWithValue:value2 andAttributes:attributesItems andAttribute:attributeItem] forKey:attributeItem];
					}
					[expense addExpense_itemsObject:newExpenseItem];
				}
		}
	
	}
	
	[app saveContext];
	
	self.callback(true);
	
}
@end
