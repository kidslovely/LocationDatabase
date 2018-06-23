//
//  SecondViewController.m
//  Loc-Final
//
//  Created by Jin.Z  on 6/13/18.
//  Copyright © 2018 Jin.Z. All rights reserved.
//

#import "SecondViewController.h"
#import "locationDisplayViewController.h"
#import "databaseObject.h"
#import "JXDatePickerView.h"
#include "Global.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationsArray = [[NSMutableArray alloc] init];
    [_locationsArray removeAllObjects];
    
    _locationToPush = [[NSMutableDictionary alloc] init];
    [_locationToPush removeAllObjects];
    _dbObj1 = [[databaseObject alloc] init];
    
    _locationsArray = [_dbObj1 getLocations];
    
    [_locationTable setDelegate:self];
    [_locationTable setDataSource:self];
    
    self.btn_selectDate.layer.cornerRadius = 5;
    // Do any additional setup after loading the view, typically from a nib.
    accformat = @"yyyy-MM-dd";
    second=self;
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    self.txt_selectedDate.text = dateString;
  
}

//- (IBAction)date_chage:(id)sender {
//
//    NSDate *date=_searchdate.date;
//
////    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
////    [outputFormatter setDateFormat:@"h:mm a"];
////    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
////    [dateFormat setDateFormat:@"yyyy-MM-dd"];
////    NSString *theDate = [dateFormat stringFromDate:date];
////    NSString *theTime = [outputFormatter stringFromDate:date];
//
//     [_locationsArray removeAllObjects];
//     _locationsArray = [_dbObj1 search_getLocations:date];
//
//    [_locationTable reloadData];
//
////    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
////        message:theDate
////       preferredStyle:UIAlertControllerStyleAlert];
////
////        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
////            handler:^(UIAlertAction * action) {}];
////
////    [alert addAction:defaultAction];
////    [self presentViewController:alert animated:YES completion:nil];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", (unsigned long)[_locationsArray count]);
    return [_locationsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"locationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"date: %@ time: %@", [[_locationsArray objectAtIndex:indexPath.row] valueForKey:@"date"], [[_locationsArray objectAtIndex:indexPath.row] valueForKey:@"time"]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    locationDisplayViewController *destination = [[locationDisplayViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    destination = (locationDisplayViewController *)[storyboard instantiateViewControllerWithIdentifier:@"locationDisplayView"];
    destination.locationRecord = [_locationsArray objectAtIndex:indexPath.row];
    
    [[self navigationController] pushViewController:destination animated:YES];
    
}
- (IBAction)selectDate:(id)sender {
    
   // dateFormats = @[@"yyyy-MM-dd", @"dd-MMM-yyyy" , @"yyyy/mm/dd"];
    
    NSInteger item = [dateFormats indexOfObject:dateformat];
    switch (item) {
        case 0:
        {  JXDatePickerView *datepicker = [[JXDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            
            NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            [self.txt_selectedDate setText:dateString];
            [self searchDate:selectDate];
            
        }];
            
            datepicker.dateLabelColor = [UIColor orangeColor];//
            datepicker.datePickerColor = [UIColor blackColor];//
            [datepicker show];
        }
        
            break;
        case 1:
        {  JXDatePickerView *datepicker = [[JXDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHour CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH"];
                [self.txt_selectedDate setText:dateString];
                [self searchDate:selectDate];
                
            }];
            
            datepicker.dateLabelColor = [UIColor orangeColor];//
            datepicker.datePickerColor = [UIColor blackColor];//
            [datepicker show];
        }
            break;
        case 2:
        {
            JXDatePickerView *datepicker = [[JXDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
                [self.txt_selectedDate setText:dateString];
                [self searchDate:selectDate];
                
            }];
            
            datepicker.dateLabelColor = [UIColor orangeColor];//
            datepicker.datePickerColor = [UIColor blackColor];//
            [datepicker show];
        }
            
            break;

        case 3:
        {  JXDatePickerView *datepicker = [[JXDatePickerView alloc] initWithDateStyle:DateStyleShowMonthDay CompleteBlock:^(NSDate *selectDate) {
            
            NSString *dateString = [selectDate stringWithFormat:@"MM-dd"];
            [self.txt_selectedDate setText:dateString];
            [self searchDate:selectDate];
            
        }];
            
            datepicker.dateLabelColor = [UIColor orangeColor];//
            datepicker.datePickerColor = [UIColor blackColor];//
            [datepicker show];
        }
            break;
            
        default:
            break;
    }
  
    
  
    
}
- (void)searchDate:(NSDate*)date
{
    [_locationsArray removeAllObjects];
    _locationsArray = [_dbObj1 search_getLocations:date];
    [_locationTable reloadData];
}


- (IBAction)chagedValue:(id)sender {
   // NSString *selected_date = self.btn_selectDate.currentTitle;
   // [self searchDate:selected_date];
}

@end
