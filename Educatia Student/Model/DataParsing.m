//
//  DataParsing.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/18/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "DataParsing.h"

@implementation DataParsing
static DataParsing *instance = nil;

+(DataParsing *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [DataParsing new];
        }
    }
    return instance;
}
@end
