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


#pragma mark - Fetching Samples
-(void)fetchSearchRepoResults {
	NSData *sampleFile = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SearchRepoSample" ofType:@"json"]];
	NSDictionary *fileDictionary = [NSJSONSerialization JSONObjectWithData:sampleFile options:0 error:nil];
	NSArray *itemArray = [fileDictionary objectForKey:@"items"];
	
	for (NSDictionary *item in itemArray) {
		if ([item objectForKey:@"owner"]) {
			NSDictionary *owner = [item objectForKey:@"owner"];
			NSString *login = [owner objectForKey:@"login"];
			
			NSLog(@"%@", login);
		}
		NSString *name = [item objectForKey:@"name"];
		NSString *url = [item objectForKey:@"html_url"];
		
		NSLog(@"%@ %@", name, url);

		
	}
}

-(void)fetchSearchUserResults {
	NSData *sampleFile = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SearchCodeSample" ofType:@"json"]];
	NSDictionary *fileDictionary = [NSJSONSerialization JSONObjectWithData:sampleFile options:0 error:nil];
	NSArray *itemArray = [fileDictionary objectForKey:@"items"];
	
	for (NSDictionary *item in itemArray) {
		NSString *login = [item objectForKey:@"login"];
		
		NSLog(@"%@", login);

	}

}

//
//
//
-(void)fetchResultsRepoSample {
	NSData *sampleFile = [[NSData alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"SearchRepoSample" ofType:@"json"]];
	
	NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:sampleFile options:0 error:nil];
	NSMutableArray *itemArray = [dataDict objectForKey:@"items"];
	NSMutableDictionary *itemDict = [itemArray firstObject];
	
	//NSLog(@"%@", dataDict);
	
	
	//fullName, idNumber, language, link, login, name
	NSString *owner = [itemDict objectForKey:@"owner"]; //Decompose further for specifics on the owner...
	NSString *repoName = [itemDict objectForKey:@"name"];
	NSString *repoFullName = [itemDict objectForKey:@"full_name"];
	NSNumber *idNumber = [itemDict objectForKey:@"id"];
	NSString *language = [itemDict objectForKey:@"language"];
	NSString *link = [itemDict objectForKey:@"url"];
	
	NSLog(@"login: %@\nRepo: %@\nID: %@", owner, repoFullName, idNumber);
	NSLog(@"Language: %@\nLink: %@", language, link);
	NSLog(@"RepoConcat: %@", repoName);
	
	
	//Put the data into an array of dictionaries for the time being, from that develop the objects later.
	
}


//
//It is good to note that the user parsing works for the application's user and the search user information.
//

-(void)fetchUserData {
	NSData *sampleFile = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserSingleSample" ofType:@"json"]];
	
	NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:sampleFile options:0 error:nil];
	//NSLog(@"%@", dataDict);
	
	NSString *name = [[NSString alloc] init];
	NSString *login = [[NSString alloc] init];
	
	name = [dataDict objectForKey:@"name"];
	login = [dataDict objectForKey:@"login"];
	
	
//	User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_dataContext];
//	user.name = name;
//	user.login = login;
	
	
}

@end
