//
//  databaseObject.h
//  Loc-Final
//
//  Created by Jin.Z  on 6/13/18.
//  Copyright © 2018 Jin.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface databaseObject : NSObject
@property (strong, nonatomic) NSString *filePath;
-(NSString*) getDbFilePath;
-(int) createTable;
-(int) insert: (float) lat : (float) longitude : (NSDate *)datestamp : (NSDate *)timestamp;
-(NSMutableArray*) getLocations;
-(NSMutableArray*) search_getLocations:(NSDate *)date;
@end
