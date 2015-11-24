//
//  AssignmentObject.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/28/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "AssignmentObject.h"

@implementation AssignmentObject

-(instancetype)initWithObject:(PFObject*)data{
    self = [super init];
    if (self){
        self.assigID            = data.objectId;
        self.assigName          = data[@"assignmentName"];
        self.assigMaxScore      = data[@"assignmentMaxScore"];
        self.assigTeacherName   = data[@"teacherName"];
        self.assigTeacherEmail  = data[@"teacherEmail"];
        self.subjectID          = data[@"subjectID"];
        self.subjectName        = data[@"subjectName"];
        self.assigDeadLine      = data[@"assignmentDeadLine"];
        PFFile *assigFile       = data[@"assignmentFile"];
        self.assigFile          = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:assigFile.url]];
        [self savefileLocally:assigFile];
    }
    return self;
}

- (void)savefileLocally:(PFFile*)file{
    if (file){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[file.url lastPathComponent]];
        [self.assigFile writeToFile:filePath atomically:YES];
        self.assigFilePath = filePath;

    }
}
@end
