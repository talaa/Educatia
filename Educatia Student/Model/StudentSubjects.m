//
//  StudentSubjects.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/29/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "StudentSubjects.h"

@implementation StudentSubjects

- (instancetype)initWithObject: (PFObject*)object{
    self = [super self];
    if (self){
        self.subjectID          = object[@"subjectID"];
        self.subjectName        = object[@"subjectName"];
        self.studentID          = object[@"studentID"];
        self.studentName        = object[@"studentName"];
        self.studentUserName    = object[@"studentUserName"];
        self.studentEmail       = object[@"studentEmail"];
        self.studentPhone       = object[@"studentPhone"];
        PFFile *studentPic      = object[@"studentProfile"];
        self.studentProfilePic = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:studentPic.url]];
    }
    return self;
}
@end
