//
//  SettingViewController.m
//  Loc-Final
//
//  Created by rjc on 6/21/18.
//  Copyright © 2018 Nickolas Donnell. All rights reserved.
//

#import "SettingViewController.h"
#import "Global.h"
@interface SettingViewController ()
{
   
    FirstViewController *firstView;
}
@end

Global *myVal; //object ;of the Global class

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dateformat = @"yyyy-MM-dd";
    
    dateFormats = @[@"yyyy-MM-dd", @"yyyy-MM-dd HH" , @"yyyy-MM-dd HH:mm" , @"MM-dd"];
    
    accuracyFormats = @[@"Best", @"Best for nav", @"100m", @"1km",@"10m", @"3km"];
    
    timeInterval = 10;
    
    self.timeInterval.text = @"10 min";
    
    self.pickerDateFormat.dataSource = self;
    self.pickerDateFormat.delegate = self;
    
    self.pickerAccuracyFormats.dataSource = self;
    self.pickerAccuracyFormats.delegate = self;
    
    self.btn_standard.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0];
    
    self.btn_hybride.layer.cornerRadius = 7;
    self.btn_satellite.layer.cornerRadius = 7;
    self.btn_standard.layer.cornerRadius = 7;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = dateFormats.count;
    if(pickerView == self.pickerAccuracyFormats)
    {
        count = accuracyFormats.count;
       
    }
    return count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.pickerAccuracyFormats)
    {
        return accuracyFormats[row];
    }
    else
    {
         return dateFormats[row];
        
    }
   
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *str;
    
    if(pickerView == self.pickerAccuracyFormats )
    {
        str = accuracyFormats[row];
        accformat = str;
        [first viewDidLoad];
    }
    else
    {
        str = dateFormats[row];
        dateformat = str;
    }
    
    //  self.TestLabel.text = str;
}

- (IBAction)SetMaptype:(id)sender {
    UIButton *btn = sender;
    
    switch (btn.tag) {
        case 1:
            self.btn_standard.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0];
            self.btn_satellite.backgroundColor =  [UIColor lightGrayColor];
            self.btn_hybride.backgroundColor = [UIColor lightGrayColor];
            mapType = 1;
           
            break;
        case 2:
          
            self.btn_standard.backgroundColor = [UIColor lightGrayColor];
            self.btn_satellite.backgroundColor =  [UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0];
            self.btn_hybride.backgroundColor = [UIColor lightGrayColor];
            mapType = 2;
         
            break;
        case 3:
            
            self.btn_standard.backgroundColor = [UIColor lightGrayColor];
            self.btn_satellite.backgroundColor =  [UIColor lightGrayColor];
            self.btn_hybride.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1.0];
             mapType =3;
         
            break;
            
        default:
            break;
    }
    [first reloadMaptype];
    
}


- (IBAction)TimeInterval:(id)sender {
    
    UISlider * slider = (UISlider *)sender;
    NSString *newVal;
    
    int minutes = roundf(slider.value);
    
    timeInterval = minutes;
    
    newVal = [NSString stringWithFormat:@"%d", minutes];
    
    newVal = [newVal stringByAppendingString:@" min"];
    
    self.timeInterval.text = newVal ;
    
}
@end
