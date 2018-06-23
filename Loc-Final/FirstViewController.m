//
//  FirstViewController.m
//  Loc-Final
//
//  Created by Jin.Z  on 6/12/18.
//  Copyright © 2018 Jin.Z. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "databaseObject.h"
#import "Global.h"

@interface FirstViewController () <CLLocationManagerDelegate>
{
    SettingViewController *setting;
}
@end

Global *myVar;   ///object of Global class

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    setting = [[SettingViewController alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    /////global/////////

   // myVar = [Global SharedSiglton];
  
    //////////global/////////
    
    timeInterval = 10;
    
    _dbObj = [[databaseObject alloc] init];
    
    [[self locationManager] setDelegate:self];
   
    if([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
    {
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[_dbObj getDbFilePath]])
    {
        [_dbObj createTable];
    }
    [[self mapView] setShowsUserLocation:YES];
    
    ///NSDate* now = [NSDate date];
    
    
    
   
//    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [[self locationManager] startUpdatingLocation];
    [self reloadMaptype];
    first = self;
    
}
-(void) reloadMaptype
{
    switch (mapType) {
        case 1:
            [[self mapView] setMapType:MKMapTypeStandard];
            
            break;
        case 2:
            [[self mapView] setMapType:MKMapTypeSatellite];
            break;
        case 3:
            [[self mapView] setMapType:MKMapTypeHybrid];
            break;
        default:
            [[self mapView] setMapType:MKMapTypeStandard];
            break;
    }
    //    dateFormats = @[@"yyyy-MM-dd", @"dd-MMM-yyyy" , @"yyyy/mm/dd"];
    //
    //    accuracyFormats = @[@"Best", @"Best for nav", @"100m", @"1km",@"10m", @"3km"];
    
    NSInteger item = [accuracyFormats indexOfObject:accformat];
    
    switch (item) {
        case 0:  //best
            [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
            break;
        case 1:  //be3st for nav
            [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
            break;
        case 2:   //100m
            [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
            break;
        case 3:    //1km
            [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyKilometer];
            break;
        case 4:   //10m
            [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
            
            break;
        case 5:   //3km
            [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
            break;
            
        default:
            [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
            break;
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    static NSDate *previous;
    static int run = 0;
    
    CLLocation *location = locations.lastObject;
    
    if(!timeInterval || timeInterval < 1) timeInterval = 1;
    if (run == 0 || [location.timestamp timeIntervalSinceDate:previous] > 60 * timeInterval)
    {
        [_dbObj insert: location.coordinate.latitude : location.coordinate.longitude : [NSDate date] : location.timestamp];
       
        [second searchDate:previous];
       
        previous = location.timestamp;
        
        run++;
    }
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2*1609.34, 2*1609.34);
    
    [[self mapView] setRegion:viewRegion animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
