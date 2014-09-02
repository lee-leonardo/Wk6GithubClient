//
//  NetworkController.h
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

//Import the models.

extern NSString * const kSearchQuery;

@interface NetworkController : NSObject

@property (nonatomic, strong) NSString *OAuthToken;

-(void)searchForQuery:(NSString *)query withType:(NSString *)type;
-(void)createRepoWithName:(NSString *)name;
-(void)fetchRepos:(id)sender;
-(void)githubAuthenticate;
-(void)handleCallbackURL:(NSURL *)url;
-(void)fetchUser;
-(void)fetchContactsWithQuery:(NSString *)query;

@end
