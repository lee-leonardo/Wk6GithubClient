//
//  CDController.h
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/29/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repository+RepoExtension.h"
#import "User+UserExtension.h"


@interface CDController : NSObject

@property (nonatomic, readonly, strong) NSFetchedResultsController *resultsController;

-(void)addedRepo:(NSData *)data;
-(void)repoParse:(NSData *)data;
-(void)contactParse:(NSData *)data;
-(void)requestDataOfModelType:(NSString *)model;

@end
