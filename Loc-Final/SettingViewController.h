//
//  SettingViewController.h
//  Loc-Final
//
//  Created by rjc on 6/21/18.
//  Copyright © 2018 Nickolas Donnell. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FirstViewController.h"

@interface SettingViewController : UITableViewController <UIPickerViewDataSource ,UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UIPickerView *pickerDateFormat;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerAccuracyFormats;

@property (weak, nonatomic) IBOutlet UILabel *timeInterval;


@property (weak, nonatomic) IBOutlet UIButton *btn_standard;
@property (weak, nonatomic) IBOutlet UIButton *btn_satellite;
@property (weak, nonatomic) IBOutlet UIButton *btn_hybride;

//- (IBAction)test:(id)sender;

- (IBAction)SetMaptype:(id)sender;


//- (IBAction)Standard:(id)sender;

- (IBAction)TimeInterval:(id)sender;

@end
