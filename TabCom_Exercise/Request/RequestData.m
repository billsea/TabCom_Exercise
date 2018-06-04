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
		}
	}];
	[dataRequestTask resume];
}
@end
