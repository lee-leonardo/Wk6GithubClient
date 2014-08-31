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
    
    for (NSDictionary *user in inputData) {
        User *userEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        userEntity.login = user[@"login"];
        NSLog(@" Login: %@", userEntity.login);
    }
    
}

@end
