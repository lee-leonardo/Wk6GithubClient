//
//  NetworkController.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "NetworkController.h"
#import "Repository+RepoExtension.h"
#import "AppDelegate.h"
#import "Constants.h"


/*
 Develop a GCD singleton.
 A token is a static variable (starts nil).
 */


@interface NetworkController() <NSURLSessionTaskDelegate>
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSManagedObjectContext *dataContext;

@end

@implementation NetworkController

- (instancetype)init
{
	self = [super init];
	if (self) {
		_appDelegate = [[UIApplication sharedApplication] delegate];
		_OAuthToken = [[NSString alloc] init];
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		
		_dataContext = _appDelegate.managedObjectContext;
		if ( [[NSUserDefaults standardUserDefaults] stringForKey:@"GithubOAuth"]) {
			_OAuthToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"GithubOAuth"];
			
			[configuration setHTTPAdditionalHeaders:@{@"Authorization": [NSString stringWithFormat:@"token %@", _OAuthToken]}];
		}
		
		_session = [NSURLSession sessionWithConfiguration:configuration];
	}
	return self;
}

#pragma mark - Repository (Self)
-(void)fetchRepos:(id)sender {
    NSLog(@"Fetch called");
    
	NSString *urlString = @"https://api.github.com/user/repos";
    NSURL *url = [[NSURL alloc] initWithString:urlString];
	
	NSURLSessionDataTask *fetchRepo = [self.session dataTaskWithURL:url
												  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
													  if (error) {
														  NSLog(@"%@", error.localizedDescription);
														  
													  } else {
														  if ( [response respondsToSelector:@selector(statusCode)]) {
															  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
															  NSInteger responseCode = [httpResponse statusCode];
															  switch (responseCode) {
																  case 200:
																	  NSLog(@"Alright.");
																	  [[_appDelegate dataController] repoParse:data];
																	  break;
																	  
																  default:
                                                                      NSLog(@"somethings wrong");
																	  break;
															  }
														  }
													  }
												  }];
	[fetchRepo resume];
	
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
}

//I have a better version of this I need to grab from my other file.
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

#pragma mark - OAuthentication
-(void)githubAuthenticate {
	//Requests access to the github API.
	NSString *urlString = [NSString stringWithFormat:kGithubOAuthURL,kGithubClientID,kGithubCallBackURI,@"user,repo"];
	//NSLog(@"githubAuthentication: %@", urlString);
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	
}

-(void)handleCallbackURL:(NSURL *)url {
	//NSLog(@"HandleCallbackURL\nurl: %@", url);
	
	//Retrieval from the request for access.
	NSString *query = url.query;
	NSArray *components = [query componentsSeparatedByString:@"code="];
	//NSLog(@"Query: %@\nComponents: %@", query, components);
	
	NSString *tempCode = [components lastObject];
	//NSLog(@"Temp Code: %@", tempCode);
	
	//POST to get the OAuth token.
	NSString *postForToken = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", kGithubClientID, kGithubClientSecret, tempCode];
	
	NSData *postData = [postForToken dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long) [postData length]];
	NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
	[postRequest setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
	[postRequest setHTTPMethod:@"POST"];
	[postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[postRequest setHTTPBody:postData];
	
	
	NSURLSessionDataTask *oAuthDataTask = [self.session dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		
		if (error) {
			NSLog(@"Error:\n%@", error.localizedDescription);
		} else {
			NSLog(@"Token: %@", response);
			
			self.OAuthToken = [self oAuthTokenParse:data];
			//NSLog(@"OAuthToken: %@", self.OAuthToken);
			
			NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
			[configuration setHTTPAdditionalHeaders:@{@"Authorization": [NSString stringWithFormat:@"token %@", _OAuthToken]}];
			_session = [NSURLSession sessionWithConfiguration:configuration];
			
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[[NSUserDefaults standardUserDefaults] setObject:_OAuthToken forKey:@"GithubOAuth"];
                
                //[self fetchRepos:self];
			}];
		}
	}];
	[oAuthDataTask resume];
}

-(NSString *)oAuthTokenParse:(NSData *)data {
	
	NSString *response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSArray *reponseComponents = [response componentsSeparatedByString:@"&"];
	NSString *accessToken = [reponseComponents firstObject];
	NSArray *accessArray = [accessToken componentsSeparatedByString:@"="];
	
	//NSLog(@"response: %@", response);
	//NSLog(@"components: %@", reponseComponents);
	//NSLog(@"Authentication array: %@", accessArray);

	return [accessArray lastObject];
}


@end
