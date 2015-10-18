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

+ (DataParsing*)getInstance;
@end
