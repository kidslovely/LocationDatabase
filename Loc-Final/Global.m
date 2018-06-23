//
//  Global.m
//  Loc-Final
//
//  Created by rjc on 6/22/18.
//  Copyright © 2018 Nickolas Donnell. All rights reserved.
//

#import "Global.h"
int mapType; ///global variable
FirstViewController *first;
SecondViewController *second;

NSArray *dateFormats;
NSArray *accuracyFormats;


NSString *dateformat;
NSString *accformat;

int timeInterval;

@implementation Global

@synthesize var1;

static Global *shared = NULL;

-(id) init
{
    if(self = [super init])
    {
        var1 = @"Standard";
    }
    return self;
}
+(Global *)SharedSiglton
{
    @synchronized(shared)
    {
        if(!shared || shared == NULL)
        {
            shared = [[Global alloc] init];
        }
        return shared;
    }
}
+(NSString *) myData
{
    return @"my data......";
}

@end
