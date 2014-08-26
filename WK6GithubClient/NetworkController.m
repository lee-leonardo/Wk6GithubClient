//
//  NetworkController.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NetworkController.h"
#import "AppDelegate.h"
#import "User.h"

struct Github {
	
};

@interface NetworkController() <NSURLSessionTaskDelegate>
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *dataContext;

@end

@implementation NetworkController

- (instancetype)init
{
	self = [super init];
	if (self) {
		_appDelegate = [[UIApplication sharedApplication] delegate];
		_dataContext = _appDelegate.managedObjectContext;
	}
	return self;
}

-(void)fetchResultsRepoSample {
	NSData *sampleFile = [[NSData alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"SearchRepoSample" ofType:@"json"]];
	
	NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:sampleFile options:0 error:nil];
	
	NSLog(@"%@", dataDict);
	
}

-(void)fetchUserSample {
	NSData *sampleFile = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserSingleSample" ofType:@"json"]];
	
	NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:sampleFile options:0 error:nil];
	NSLog(@"%@", dataDict);
	
	NSString *name = [[NSString alloc] init];
	NSString *login = [[NSString alloc] init];
	
	name = [dataDict objectForKey:@"name"];
	login = [dataDict objectForKey:@"login"];
	
	NSLog(@"%@ and %@", name, login);
	
//	User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_dataContext];
//	user.name = name;
//	user.login = login;
	
	
}

@end
