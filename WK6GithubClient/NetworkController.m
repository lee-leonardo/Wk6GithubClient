//
//  NetworkController.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "NetworkController.h"

struct Github {
	
};

@interface NetworkController() <NSURLSessionTaskDelegate>

@end

@implementation NetworkController

-(void)fetchResultsTest {
	NSData *sampleFile = [[NSData alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"SearchRepoSample" ofType:@"json"]];
	
	NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:sampleFile options:0 error:nil];
	
	NSLog(@"%@", dataDict);
	
}

@end
