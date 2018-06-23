//
//  Global.h
//  Loc-Final
//
//  Created by rjc on 6/22/18.
//  Copyright © 2018 Nickolas Donnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FirstViewController.h"
#include "SecondViewController.h"
extern int mapType;   //{1: standard 2:satelite  3: hybride }///  global variable
extern FirstViewController *first;
extern SecondViewController *second;
extern  NSArray *dateFormats;
extern  NSArray *accuracyFormats;
extern int timeInterval;

extern NSString *dateformat;
extern NSString *accformat;
@interface Global : NSObject
{
    NSString *var1;  ///singlton
    
}
@property(nonatomic, retain) NSString *var1;

+(Global * )SharedSiglton;

+(NSString *)myData;

@end
