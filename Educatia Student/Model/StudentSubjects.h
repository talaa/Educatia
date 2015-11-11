//
//  StudentSubjects.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/29/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface StudentSubjects : NSObject

@property (strong, nonatomic) NSString *subjectID;
@property (strong, nonatomic) NSString *subjectName;
@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSString *studentUserName;
@property (strong, nonatomic) NSString *studentName;
@property (strong, nonatomic) NSString *studentPhone;
@property (strong, nonatomic) NSString *studentEmail;
@property (strong, nonatomic) NSData   *studentProfilePic;

- (instancetype)initWithObject:(PFObject*)object;

@end
