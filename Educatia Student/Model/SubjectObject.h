//
//  SubjectObject.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/28/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SubjectObject : NSObject

@property (strong, nonatomic) NSString  *objectID;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSData    *logo;
@property (strong, nonatomic) NSString  *teacherUserName;
@property (strong, nonatomic) NSString  *teacherName;

- (instancetype)initWithObject:(PFObject *)object;
@end
