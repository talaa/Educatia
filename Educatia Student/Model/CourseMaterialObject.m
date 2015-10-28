//
//  CourseMaterialObject.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/27/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "CourseMaterialObject.h"

@implementation CourseMaterialObject
-(instancetype)initWithObject:(PFObject*)data{
    self=[super init];
    if(self){
        self.name = data[@"cmName"];
        self.teacher = data[@"cmTeacherName"];
        PFFile *cmFile = data[@"cmFile"];
        NSData *cmFileData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:cmFile.url]];
        self.dataFile =cmFileData;
        [self SaveFilePath:cmFile];
    }
    return self;
}

-(void)SaveFilePath:(PFFile*)file{
    if (self.dataFile)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[file.url lastPathComponent]];
        [self.dataFile writeToFile:filePath atomically:YES];
        self.filePath =filePath;
    }
}
@end
