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
 NSDateFormatter !! -> Use this to generate a date from a string.
 Created is the most common of the dates.
 
 */
NSString * const kSearchQuery = @"https://api.github.com/search/users?sort=%@&order=%@&q=%@";

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

#pragma mark - Search
-(void)searchForQuery:(NSString *)query withType:(NSString *)type {
    
    //I'm locked out of my constants (because I recovered the project... so I'm using this for the time being.
    NSString *typeLink;
    if ([type  isEqual: @"Repositories"]) {
        typeLink = @"search/repositories";
    } else if ( [type  isEqual: @"Users"]) {
        typeLink = @"search/users";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/%@/?q=%@&sort=desc", typeLink, query];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [[self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Search Error: %@", error.localizedDescription);
        } else {
            if ([response respondsToSelector:@selector(statusCode)]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                NSInteger responseCode = [httpResponse statusCode];
                NSLog(@"Fetch Repos: %lu", (long)responseCode);
                switch (responseCode) {
                    case 200:
                        [[_appDelegate dataController] searchParse:data withType:type];
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }] resume];
    
}

#pragma mark - Repository (Self)
-(void)fetchRepos:(id)sender {
    //NSLog(@"Fetch called");
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.github.com/user/repos"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
	
	NSURLSessionDataTask *fetchRepo = [self.session dataTaskWithURL:url
												  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
													  if (error) {
														  NSLog(@"Fetch Repos Error: %@", error.localizedDescription);
														  
													  } else {
														  if ( [response respondsToSelector:@selector(statusCode)]) {
															  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
															  NSInteger responseCode = [httpResponse statusCode];
                                                              NSLog(@"Fetch Repos: %lu", (long) responseCode);
															  switch (responseCode) {
																  case 200:
																	  //NSLog(@"Alright.");
																	  [[_appDelegate dataController] repoParse:data];
																	  break;
																	  
																  default:
                                                                      NSLog(@"somethings wrong. Error: %lu", (long)responseCode);
																	  break;
															  }
														  }
													  }
												  }];
	[fetchRepo resume];
	
}

-(void)fetchContactsWithQuery:(NSString *)query {
    NSString *urlString = [[NSString alloc] initWithFormat: kSearchQuery, @"followers", @"asc", query];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [[self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Fetch Contacts Error: %@", error.localizedDescription);
        } else {
            if ([response respondsToSelector:@selector(statusCode)]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSInteger responseCode = [httpResponse statusCode];
                switch (responseCode) {
                    case 200:
                        NSLog(@"Contacts Fetch: %lu", (long)responseCode);
                        [[_appDelegate dataController] contactParse:data];
                        break;
                        
                    default:
                        NSLog(@"Contacts FetchL %lu", (long)responseCode);
                        break;
                }
            }
        }
    }] resume];
}

#pragma mark Create Repo
-(void)createRepoWithName:(NSString *)name {
    
    NSDictionary *post = @{@"name":name};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:post options:0 error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *createString = [[NSString alloc] initWithFormat:@"https://api.github.com/user/repos?scope=public_repo"];
    NSURL *createURL = [[NSURL alloc] initWithString:createString];

    NSMutableURLRequest *createRequest = [[NSMutableURLRequest alloc] init];
    [createRequest setURL:createURL];
    [createRequest setHTTPMethod:@"POST"];
    [createRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [createRequest setValue:[NSString stringWithFormat:@"token %@", _OAuthToken] forHTTPHeaderField:@"Authorization"];
    [createRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [createRequest setHTTPBody:postData];
    
    //This is where the NSURLSessionDataTask happens.
    NSURLSessionDataTask *createRepoTask = [self.session dataTaskWithRequest:createRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Create Repo Error: %@", error.localizedDescription);
        } else {
            if ([response respondsToSelector:@selector(statusCode)]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSInteger responseCode = [httpResponse statusCode];
                switch (responseCode) {
                    case 201:
                        NSLog(@"Create Repo %lu", (long)responseCode);
                        //Needs a special parse method or data wrapper.
                        [[_appDelegate dataController] addedRepo:data];
                        break;
                        
                    default:
                        NSLog(@"Somethings wrong... like even 200 is wrong here.");
                        NSLog(@"%ld", (long)responseCode);
                        break;
                }
            }
        }
    }];
    [createRepoTask resume];
}

#pragma mark - Contact
-(void)fetchUser {
    NSString *urlString = [[NSString alloc] initWithFormat:kSearchQuery, @"followers", @"asc", @"octocat" ];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [[self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Fetch User Error: %@", error.localizedDescription);
        } else {
            if ([response respondsToSelector:@selector(statusCode)]) {
                NSHTTPURLResponse *httpReponse = (NSHTTPURLResponse *)response;
                NSInteger reponseCode = [httpReponse statusCode];
                switch (reponseCode) {
                    case 200:
                        [[_appDelegate dataController] contactParse:data];
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }] resume];
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
			NSLog(@"OAuth Callback Error:\n%@", error.localizedDescription);
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
