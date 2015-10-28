//
//  UserObject.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/28/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserObject : NSObject

@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSData *profPic;
@property (strong, nonatomic) NSString *type;

- (instancetype)initWithObject:(PFObject *)object;

@end
