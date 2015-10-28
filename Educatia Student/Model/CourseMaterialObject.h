//
//  CourseMaterialObject.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/27/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CourseMaterialObject : NSObject


@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* teacher;
@property(strong,nonatomic) NSData* dataFile;
@property(strong,nonatomic) NSString* filePath;

-(instancetype)initWithObject:(PFObject*)data;
@end
