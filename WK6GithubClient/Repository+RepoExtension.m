//
//  Repository+RepoExtension.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "Repository+RepoExtension.h"
#import <CoreData/CoreData.h>

@implementation Repository (RepoExtension)
//


+(void)generateRepoData:(NSArray *)repoList withContext:(NSManagedObjectContext *)context {

    for (NSDictionary *repo in repoList) {
        //NSLog(@"Repo data: %@", repo);
        //NSLog(@"Fullname: %@", repo[@"full_name"]);
        //NSLog(@"Language: %@", repo[@"language"]);

        Repository *repository = [NSEntityDescription insertNewObjectForEntityForName:@"Repository" inManagedObjectContext:context];
        repository.login = repo[@"owner"][@"login"];
        repository.fullName = repo[@"full_name"];
        repository.language = repo[@"language"];
        repository.link = repo[@"html_url"]; //For right now, it is a html url.
        
        NSLog(@"Login: %@" ,repository.login);

    }
    
}


@end
