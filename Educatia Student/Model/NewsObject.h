//
//  NewsObject.h
//  Educatia Student
//
//  Created by Mena Bebawy on 11/11/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface NewsObject : NSObject

@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *subjectID;

- (instancetype)initWithObject:(PFObject*)object;
@end
