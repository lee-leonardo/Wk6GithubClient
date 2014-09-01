//
//  User+UserExtension.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "User+UserExtension.h"

@implementation User (UserExtension)

//bio, blog, company, email, hireable, location, name
+(void)generateContactsData:(NSArray *)inputData withContext:(NSManagedObjectContext *)context {
    //NSLog(@"Array:\n%@", inputData);
    
    for (NSDictionary *user in inputData) {
        User *userEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        userEntity.login = user[@"login"];
        userEntity.imageURL = user[@"avatar_url"];
        userEntity.link = user[@"html_url"];
        userEntity.followersURL = user[@"followers_url"];
        userEntity.followingURL = user[@"following_url"];

        //NSLog(@" Login: %@", userEntity.login);
        //NSLog(@"%@", userEntity);
    }
    
}

@end
