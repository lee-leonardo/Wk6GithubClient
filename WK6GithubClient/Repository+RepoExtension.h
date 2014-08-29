//
//  Repository+RepoExtension.h
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "Repository.h"

@interface Repository (RepoExtension)
+(void)generateRepoData:(NSArray *)repoList withContext:(NSManagedObjectContext *)context;

@end
