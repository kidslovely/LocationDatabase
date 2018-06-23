//
//  databaseObject.m
//  Loc-Final
//
//  Created by Jin.Z  on 6/13/18.
//  Copyright © 2018 Jin.Z. All rights reserved.
//

#import "databaseObject.h"
#import <sqlite3.h>

@implementation databaseObject

-(instancetype)init
{
    _filePath = [self getDbFilePath];
    return self;
}

-(NSString*) getDbFilePath
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingString:@"/locations.db"];
}

-(int)createTable
{
    sqlite3 *db = NULL;
    int rc = 0;
    
    rc = sqlite3_open_v2([_filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db... CREATE");
    }
    else
    {
        char* query = "CREATE TABLE IF NOT EXISTS logs ( id INTEGER PRIMARY KEY AUTOINCREMENT, latitude REAL, longitude REAL, date TEXT, time TEXT)";
        char* errMsg;
        rc = sqlite3_exec(db, query, NULL, NULL, &errMsg);
        
        if (SQLITE_OK != rc)
        {
            NSLog(@"Couldn't create db...");
        }
        sqlite3_close(db);
    }
    
    return rc;
}

-(int) insert:(float)latitude : (float)longitude : (NSDate *)datestamp : (NSDate *)timestamp
{
    int rc = 0;
    sqlite3* db = NULL;
    
    
    rc = sqlite3_open_v2([_filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE, NULL);
    
    if(SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db... insert");
    }
    else
    {
        NSString *dateString = [[NSString alloc] init];
        NSString *timeString = [[NSString alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"HH:mm"];
        
        dateString = [dateFormatter stringFromDate:datestamp];
        
        timeString = [dateFormatter2 stringFromDate:timestamp];
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO logs (latitude, longitude, date, time) VALUES (\"%.3f\", \"%.3f\", \"%@\", \"%@\")", latitude, longitude, dateString, timeString];
        
        char *errMsg;
        rc = sqlite3_exec(db, [query UTF8String], NULL, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update db...");
        }
        sqlite3_close(db);
        NSLog(@"Inserted a new record... lat: %.3f long: %.3f date: %@ time: %@", latitude, longitude, dateString, timeString);
    }
    
    
    return rc;
}

-(NSMutableArray*) getLocations
{
    sqlite3 *db = NULL;
    int rc = 0;
    sqlite3_stmt *stmt = NULL;
    
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    
    rc = sqlite3_open_v2([_filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READONLY, NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db in getLocations...   %d %d", SQLITE_OK, rc);
    }
    else
    {
        NSString *query = @"SELECT * from logs";
        rc = sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                NSNumber *lat = [NSNumber numberWithFloat:(float)sqlite3_column_double(stmt, 1)];
                NSNumber *lon = [NSNumber numberWithFloat:(float)sqlite3_column_double(stmt, 2)];
                NSString *date = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                NSString *time = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                NSDictionary *coordinates = [NSDictionary dictionaryWithObjectsAndKeys:lat,@"latitude", lon, @"longitude", date, @"date", time, @"time", nil];
                
                [locationArray addObject:coordinates];
            }
        }
        else
        {
            NSLog(@"Failed to Prep Statement...");
        }
        sqlite3_close(db);
    }
    
    
    return locationArray;
}
-(NSMutableArray*) search_getLocations:(NSDate *)date
{
    sqlite3 *db = NULL;
    int rc = 0;
    sqlite3_stmt *stmt = NULL;
    
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    
    rc = sqlite3_open_v2([_filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READONLY, NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db in getLocations...   %d %d", SQLITE_OK, rc);
    }
    else
    {
        NSString *dateString = [[NSString alloc] init];
        NSString *timeString = [[NSString alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"HH:mm"];
        
        dateString = [dateFormatter stringFromDate:date];
        
        timeString = [dateFormatter2 stringFromDate:date];
     //    NSString *query = [NSString stringWithFormat:@"SELECT * FROM logs WHERE date='%@'",dateString];
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM logs WHERE date='%@' AND time='%@'",dateString, timeString];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM logs WHERE date='%@' OR time='%@'",dateString, timeString];
        rc = sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                NSNumber *lat = [NSNumber numberWithFloat:(float)sqlite3_column_double(stmt, 1)];
                NSNumber *lon = [NSNumber numberWithFloat:(float)sqlite3_column_double(stmt, 2)];
                NSString *date = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                NSString *time = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                NSDictionary *coordinates = [NSDictionary dictionaryWithObjectsAndKeys:lat,@"latitude", lon, @"longitude", date, @"date", time, @"time", nil];
                
                [locationArray addObject:coordinates];
            }
        }
        else
        {
            NSLog(@"Failed to Prep Statement...");
        }
        sqlite3_close(db);
    }
    
    
    return locationArray;
}
@end
