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

- (void)parseResponse:(id)responseObject {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = app.persistentContainer.viewContext;
	NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:context];
	
	//get attributes(names) from data model
	NSDictionary *attributes = [entityDesc attributesByName];
	NSArray* items = (NSArray*)responseObject;

	//Loop through results, and map to data model
	for(NSDictionary* item in items) {
		for (NSString *attribute in attributes) {
			id value = [item objectForKey:attribute];
			if (value == nil) {
				continue;
			}
			
			//Create new Expense object ..TODO: existing or new?
		  NSManagedObject* expenseObject = [NSEntityDescription insertNewObjectForEntityForName:entityDesc.name inManagedObjectContext:context];
			
			//Handle data types
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
			
			//TODO: items dictionary !!!
			
			//set value
			[expenseObject setValue:value forKey:attribute];
		}
	}
	
	[app saveContext];
	
}
@end
