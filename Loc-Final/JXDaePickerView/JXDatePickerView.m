//
//  JXDatePickerView.m
//  DatePicker
//
//  Created by Destiny on 2018/5/7.
//  Copyright © 2018年 Jin.Z.  All rights reserved.
//

#import "JXDatePickerView.h"
#import "UIView+Extension.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPickerSize self.datePicker.frame.size
#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define RGB(r, g, b) RGBA(r,g,b,1)
// 判断是否是iPhone X
#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// home indicator
#define bottom_height (isiPhoneX ? 1.f : 1.f)


#define MAXYEAR 2099
#define MINYEAR 1000

#define KPickerViewHeight 280
#define kHeightOfButtonContentView 40.0
#define kRowDisabledStatusColor [UIColor redColor]
#define kRowNormalStatusColor [UIColor blackColor]
#define kButtonNormalStatusColor [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]

typedef void(^doneBlock)(NSDate *);

@interface JXDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate> {
    //日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSString *_dateFormatter;
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSInteger preRow;
}

@property (strong, nonatomic)  UILabel *showYearView;
@property (strong, nonatomic) UIView *contentView;

@property (nonatomic,strong) UIPickerView *datePicker;
@property (nonatomic, retain) NSDate *scrollToDate;//滚到指定日期
@property (nonatomic,strong) doneBlock doneBlock;
@property (nonatomic,assign) JXDateStyle datePickerStyle;
@property (strong, nonatomic) NSDate*startDate;


@end

@implementation JXDatePickerView

/**
 默认滚动到当前时间
 */
-(instancetype)initWithDateStyle:(JXDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock {
    self = [super init];
    if (self) {
    
        self = [[JXDatePickerView alloc]init];

        self.datePickerStyle = datePickerStyle;
        switch (datePickerStyle) {
            case DateStyleShowYearMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case DateStyleShowYearMonthDayHour:
                _dateFormatter = @"yyyy-MM-dd HH";
                break;
            case DateStyleShowMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case DateStyleShowYearMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case DateStyleShowYearMonth:
                _dateFormatter = @"yyyy-MM";
                break;
            case DateStyleShowMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case DateStyleShowHourMinute:
                _dateFormatter = @"HH:mm";
                break;
                
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self setupUI];
        [self defaultConfig];
        
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

/**
 滚动到指定的的日期
 */
-(instancetype)initWithDateStyle:(JXDateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock {
    self = [super init];
    if (self) {
       self = [[JXDatePickerView alloc]init];
    
        self.datePickerStyle = datePickerStyle;
        self.scrollToDate = scrollToDate;
        switch (datePickerStyle) {
            case DateStyleShowYearMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case DateStyleShowYearMonthDayHour:
                _dateFormatter = @"yyyy-MM-dd HH";
                break;
            case DateStyleShowMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case DateStyleShowYearMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case DateStyleShowYearMonth:
                _dateFormatter = @"yyyy-MM";
                break;
            case DateStyleShowMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case DateStyleShowHourMinute:
                _dateFormatter = @"HH:mm";
                break;
                
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self setupUI];
        [self defaultConfig];
        
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

-(void)setupUI {
    
    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    _contentView = [UIView new];
    _contentView.frame = CGRectMake(0, self.bottom, self.width, KPickerViewHeight);
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    // 初始化头部按钮（取消、现在时间、确定）
    UIView *buttonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, self.width, kHeightOfButtonContentView)];
    buttonContentView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [_contentView addSubview:buttonContentView];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(2.0, 2.5, 60.0, kHeightOfButtonContentView - 5.0);
    btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:kButtonNormalStatusColor forState:UIControlStateNormal];
    [btnCancel addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [buttonContentView addSubview:btnCancel];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    btnConfirm.frame = CGRectMake(self.width - 58.0, 2.5, 60.0, kHeightOfButtonContentView - 5.0);
    btnConfirm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnConfirm setTitle:@"OK" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:kButtonNormalStatusColor forState:UIControlStateNormal];
    [btnConfirm addTarget:self
                   action:@selector(doneAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonContentView addSubview:btnConfirm];
    
    _showYearView = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeightOfButtonContentView, self.width, _contentView.height - kHeightOfButtonContentView)];
    _showYearView.font = [UIFont systemFontOfSize:110];
    _showYearView.textAlignment = NSTextAlignmentCenter;
    _showYearView.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [_contentView addSubview:_showYearView];
    
    // 初始化选择器视图控件
    _datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, kHeightOfButtonContentView, self.width, _contentView.height - kHeightOfButtonContentView)];
    _datePicker.showsSelectionIndicator = YES;
    _datePicker.backgroundColor = [UIColor clearColor];
    _datePicker.dataSource = self;
    _datePicker.delegate = self;
    [_contentView addSubview:_datePicker];
    
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
}

-(void)defaultConfig {
    
    if (!_scrollToDate) {
        _scrollToDate = [NSDate date];
    }
    
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    //设置年月日时分数据
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];
    _dayArray = [self setArray:_dayArray];
    _hourArray = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    
    for (int i=0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12)
            [_monthArray addObject:num];
        if (i<24)
            [_hourArray addObject:num];
        [_minuteArray addObject:num];
    }
    for (NSInteger i=MINYEAR; i<=MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"2099-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:@"1000-01-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
}

-(void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.showYearView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (!_dateLabelColor) {
        _dateLabelColor =  RGB(247, 133, 51);
    }
    
    for (int i=0; i<nameArr.count; i++) {
        CGFloat labelX = kPickerSize.width/(nameArr.count*2)+18+kPickerSize.width/nameArr.count*i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.showYearView.frame.size.height/2-15/2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =  _dateLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [self.showYearView addSubview:label];
    }
}


-(void)setDateLabelColor:(UIColor *)dateLabelColor {
    _dateLabelColor = dateLabelColor;
    for (id subView in self.showYearView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = subView;
            label.textColor = _dateLabelColor;
        }
    }
}


- (NSMutableArray *)setArray:(id)mutableArray
{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

-(void)setYearLabelColor:(UIColor *)yearLabelColor {
    self.showYearView.textColor = yearLabelColor;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            [self addLabelWithName:@[@"y",@"m",@"d",@"h",@"m"]];
            return 5;
        case DateStyleShowYearMonthDayHour:
            [self addLabelWithName:@[@"y",@"mo",@"d",@"h"]];
            return 4;
        case DateStyleShowMonthDayHourMinute:
            [self addLabelWithName:@[@"m",@"d",@"h",@"m"]];
            return 4;
        case DateStyleShowYearMonthDay:
            [self addLabelWithName:@[@"y",@"m",@"d"]];
            return 3;
        case DateStyleShowYearMonth:
            [self addLabelWithName:@[@"y",@"m"]];
            return 2;
        case DateStyleShowMonthDay:
            [self addLabelWithName:@[@"m",@"d"]];
            return 2;
        case DateStyleShowHourMinute:
            [self addLabelWithName:@[@"h",@"m"]];
            return 2;
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue] * 100;
}

-(NSArray *)getNumberOfRowsInComponent {
    
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    
    NSInteger timeInterval = MAXYEAR - MINYEAR;
    
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case DateStyleShowYearMonthDayHour:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum)];
            break;
        case DateStyleShowMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case DateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        case DateStyleShowYearMonth:
            return @[@(yearNum),@(monthNum)];
            break;
        case DateStyleShowMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
        case DateStyleShowHourMinute:
            return @[@(hourNum),@(minuteNUm)];
            break;
        default:
            return @[];
            break;
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:17]];
    }
    NSString *title;
    
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            if (component==0) {
                title = _yearArray[row % _yearArray.count];
            }
            if (component==1) {
                title = _monthArray[row % _monthArray.count];
            }
            if (component==2) {
                title = _dayArray[row % _dayArray.count];
            }
            if (component==3) {
                title = _hourArray[row % _hourArray.count];
            }
            if (component==4) {
                title = _minuteArray[row % _minuteArray.count];
            }
            break;
        case DateStyleShowYearMonthDayHour:
            if (component==0) {
                title = _yearArray[row % _yearArray.count];
            }
            if (component==1) {
                title = _monthArray[row % _monthArray.count];
            }
            if (component==2) {
                title = _dayArray[row % _dayArray.count];
            }
            if (component==3) {
                title = _hourArray[row % _hourArray.count];
            }
            break;
        case DateStyleShowYearMonthDay:
            if (component==0) {
                title = _yearArray[row % _yearArray.count];
            }
            if (component==1) {
                title = _monthArray[row % _monthArray.count];
            }
            if (component==2) {
                title = _dayArray[row % _dayArray.count];
            }
            break;
        case DateStyleShowYearMonth:
            if (component==0) {
                title = _yearArray[row % _yearArray.count];
            }
            if (component==1) {
                title = _monthArray[row % _monthArray.count];
            }
            break;
        case DateStyleShowMonthDayHourMinute:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row % _dayArray.count];
            }
            if (component==2) {
                title = _hourArray[row % _hourArray.count];
            }
            if (component==3) {
                title = _minuteArray[row % _minuteArray.count];
            }
            break;
        case DateStyleShowMonthDay:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row % _dayArray.count];
            }
            break;
        case DateStyleShowHourMinute:
            if (component==0) {
                title = _hourArray[row % _hourArray.count];
            }
            if (component==1) {
                title = _minuteArray[row % _minuteArray.count];
            }
            break;
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
    if (!_datePickerColor) {
        _datePickerColor = [UIColor blackColor];
    }
    customLabel.textColor = _datePickerColor;
    return customLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:{
            
            if (component == 0) {
                yearIndex = row % _yearArray.count;
                
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row % _monthArray.count;
            }
            if (component == 2) {
                dayIndex = row % _dayArray.count;
            }
            if (component == 3) {
                hourIndex = row % _hourArray.count;
            }
            if (component == 4) {
                minuteIndex = row % _minuteArray.count;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                    [_datePicker selectRow:dayIndex inComponent:2 animated:NO];
                }
                
            }
        }
            break;
        case DateStyleShowYearMonthDayHour:{
            
            if (component == 0) {
                yearIndex = row % _yearArray.count;
                
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row % _monthArray.count;
            }
            if (component == 2) {
                dayIndex = row % _dayArray.count;
            }
            if (component == 3) {
                hourIndex = row % _hourArray.count;
            }
           
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                    [_datePicker selectRow:dayIndex inComponent:2 animated:NO];
                }
                
            }
        }
            break;
            
            
        case DateStyleShowYearMonthDay:{
            
            if (component == 0) {
                yearIndex = row % _yearArray.count;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row % _monthArray.count;
            }
            if (component == 2) {
                dayIndex = row % _dayArray.count;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                    
                    [_datePicker selectRow:dayIndex inComponent:2 animated:NO];
                }
            }
        }
            break;
        
        case DateStyleShowYearMonth:{
            
            if (component == 0) {
                yearIndex = row % _yearArray.count;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row % _monthArray.count;
            }
        }
            break;
            
            
        case DateStyleShowMonthDayHourMinute:{
            if (component == 1) {
                dayIndex = row % _dayArray.count;
            }
            if (component == 2) {
                hourIndex = row % _hourArray.count;
            }
            if (component == 3) {
                minuteIndex = row % _minuteArray.count;
            }
            
            if (component == 0) {
                
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                    [_datePicker selectRow:dayIndex inComponent:2 animated:NO];
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
            
        }
            break;
            
        case DateStyleShowMonthDay:{
            if (component == 1) {
                dayIndex = row % _dayArray.count;
            }
            if (component == 0) {
                
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                    [_datePicker selectRow:dayIndex inComponent:1 animated:NO];
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
            
        case DateStyleShowHourMinute:{
            if (component == 0) {
                hourIndex = row % _hourArray.count;
            }
            if (component == 1) {
                minuteIndex = row % _minuteArray.count;
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",
                         _yearArray[yearIndex],
                         _monthArray[monthIndex],
                         _dayArray[dayIndex],
                         _hourArray[hourIndex],
                         _minuteArray[minuteIndex]];
    
    _scrollToDate = [[NSDate date:dateStr WithFormat:@"yyyy-MM-dd HH:mm"] dateWithFormatter:_dateFormatter];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    
    _startDate = self.scrollToDate;
    
}

-(void)yearChange:(NSInteger)row {
    
    monthIndex = row%12;
    
    //年份状态变化
    if (row-preRow <12 && row-preRow>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow%12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    }else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    
    self.showYearView.text = _yearArray[yearIndex];
    
    preRow = row;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if( [touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark - Action
-(void)show {
    
    CGRect rect = self.contentView.frame;
    rect.origin.y = self.bottom-KPickerViewHeight;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.frame = rect;
    }];
}

-(void)dismiss {
    CGRect rect = self.contentView.frame;
    rect.origin.y = self.bottom;
    [UIView animateWithDuration:.2 animations:^{
         self.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self dismiss];
}

- (IBAction)doneAction:(UIButton *)btn {
    
    _startDate = [self.scrollToDate dateWithFormatter:_dateFormatter];
    
    self.doneBlock(_startDate);
    [self dismiss];
}

#pragma mark - tools
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    
    [self DaysfromYear:date.year andMonth:date.month];
    
    yearIndex = date.year-MINYEAR;
    monthIndex = date.month-1;
    dayIndex = date.day-1;
    hourIndex = date.hour;
    minuteIndex = date.minute;
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray;
    
    if (self.datePickerStyle == DateStyleShowYearMonthDayHourMinute)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == DateStyleShowYearMonthDayHour)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex)];
    if (self.datePickerStyle == DateStyleShowYearMonthDay)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == DateStyleShowYearMonth)
        indexArray = @[@(yearIndex),@(monthIndex)];
    if (self.datePickerStyle == DateStyleShowMonthDayHourMinute)
        indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == DateStyleShowMonthDay)
        indexArray = @[@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == DateStyleShowHourMinute)
        indexArray = @[@(hourIndex),@(minuteIndex)];
    
    self.showYearView.text = _yearArray[yearIndex];
    
    [self.datePicker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        if ((self.datePickerStyle == DateStyleShowMonthDayHourMinute || self.datePickerStyle == DateStyleShowMonthDay)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.year - MINYEAR));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
        
    }
}


#pragma mark - getter / setter
-(UIPickerView *)datePicker {
    if (!_datePicker) {
        [self.showYearView layoutIfNeeded];
        _datePicker = [[UIPickerView alloc] initWithFrame:self.showYearView.bounds];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

-(void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
}

-(void)setDoneButtonColor:(UIColor *)doneButtonColor {
    _doneButtonColor = doneButtonColor;
}

-(void)setHideBackgroundYearLabel:(BOOL)hideBackgroundYearLabel {
    _showYearView.textColor = [UIColor clearColor];
}

@end