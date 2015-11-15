//
//  NewsObject.m
//  Educatia Student
//
//  Created by Mena Bebawy on 11/11/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "NewsObject.h"

@implementation NewsObject

- (instancetype)initWithObject:(PFObject*)object{
    self = [super self];
    if (self){
        self.subject    = object[@"newsSubject"];
        self.text       = object[@"newsText"];
        self.date       = object.createdAt;
        self.subjectID  = object[@"subjectID"];
    }
    return self;
}

@end
