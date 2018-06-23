//
//  locationDisplayViewController.h
//  Loc-Final
//
//  Created by Jin.Z  on 6/13/18.
//  Copyright © 2018 Jin.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface locationDisplayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *dateField;
//@property (weak, nonatomic) IBOutlet UITextField *timeField;

@property (weak, nonatomic) IBOutlet UITextView *addressField;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableDictionary *locationRecord;
@property (strong, nonatomic) MKPointAnnotation *currentAnnotation;

@end
