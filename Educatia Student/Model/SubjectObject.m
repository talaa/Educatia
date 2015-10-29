//
//  SubjectObject.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/28/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "SubjectObject.h"

@implementation SubjectObject

- (instancetype)initWithObject:(PFObject *)object{
    self = [super self];
    if (self){
        self.name = object[@"subjectName"];
        self.objectID = object.objectId;
        self.teacherName = object[@"teacherFullName"];
        self.teacherUserName = object[@"teacherUserName"];
        PFFile *logoFile = object[@"subjectLogo"];
        self.logo = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:logoFile.url]];
    }
    return self;
}
@end
