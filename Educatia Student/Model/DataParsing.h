//
//  DataParsing.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/18/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParsing : NSObject
@property (nonatomic , retain) NSString *subjectName;
@property (nonatomic , retain) NSString *subjectID;
@property (nonatomic , retain) NSString *currentUserusername;
@property (nonatomic , retain) NSString *currentUseruserID;
@property (nonatomic , retain) NSString *currentUserName;
@property (assign) BOOL isCurrentTeacher;
+ (DataParsing*)getInstance;
@end
