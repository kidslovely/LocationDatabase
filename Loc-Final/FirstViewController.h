//
//  FirstViewController.h
//  Loc-Final
//
//  Created by Jin.Z  on 6/12/18.
//  Copyright © 2018 Jin.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "databaseObject.h"
#import "SettingViewController.h"

@interface FirstViewController : UIViewController

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) databaseObject *dbObj;

-(void) reloadMaptype;
@end
