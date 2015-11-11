//
//  UserObject.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/28/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

- (instancetype)initWithObject:(PFObject *)object{
    self = [super self];
    if (self) {
        self.objectID = object[@"objectId"];
        self.firstName = object[@"FirstName"];
        self.lastName = object[@"LastName"];
        self.phone = object[@"Phone"];
        self.email = object[@"email"];
        PFFile *userProfilePic = object[@"profilePicture"];
        self.profPic = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:userProfilePic.url]];
    }
    return self;
}
@end
