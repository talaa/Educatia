//
//  AssignmentObject.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/28/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AssignmentObject : NSObject

@property (strong, nonatomic) NSString  *assigID;
@property (strong, nonatomic) NSString  *assigName;
@property (strong, nonatomic) NSString  *assigTeacherName;
@property (strong, nonatomic) NSString  *assigTeacherEmail;
@property (strong, nonatomic) NSString  *subjectID;
@property (strong, nonatomic) NSString  *subjectName;
@property (strong, nonatomic) NSString  *assigMaxScore;
@property (strong, nonatomic) NSDate    *assigDeadLine;
@property (strong, nonatomic) NSData    *assigFile;
@property (strong, nonatomic) NSString  *assigFilePath;

-(instancetype)initWithObject:(PFObject*)data;

@end
