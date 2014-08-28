//
//  NetworkController.h
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//Import the models.

@interface NetworkController : NSObject

@property (nonatomic, strong) NSString *OAuthToken;

-(void)githubAuthenticate;
-(void)handleCallbackURL:(NSURL *)url;
-(void)repoParse;

-(void)fetchResultsRepoSample;
-(void)fetchUserData;

@end
