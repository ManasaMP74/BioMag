#import "DatePicker.h"
#import "AppDelegate.h"
#import <MCLocalization/MCLocalization.h>
#import "Constant.h"
@implementation DatePicker
{
    UIView *view;
    NSDateFormatter *formater;
    NSString *date;
    UIControl  *alphaView;
    Constant *constant;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"DatePickerView" owner:self options:nil]lastObject];
    [self initializeView];
    [self addSubview:view];
    view.frame=self.bounds;
    _datePicker.datePickerMode=1;
   // _datePicker.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]];
   // [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-2.jpg"]]];
    return self;
}
-(void)initializeView
{
    constant=[[Constant alloc]init];
    [_cancelButton setTitle:[MCLocalization stringForKey:@"Cancel"] forState:normal];
    [_doneButton setTitle:[MCLocalization stringForKey:@"Done"] forState:normal];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    _doneButton.layer.cornerRadius=21;
    _cancelButton.layer.cornerRadius=21;
    formater=[[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone localTimeZone]];
    [formater setDateFormat:@"dd-MMM-yyyy"];
    date=[formater stringFromDate:self.datePicker.date];
     [_datePicker setValue:[UIColor lightGrayColor] forKey:@"textColor"];
      [constant getTheAllSaveButtonImage:_doneButton];
}
- (IBAction)datePickerAction:(id)sender {
    date=[formater stringFromDate:self.datePicker.date];
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        [alphaView addSubview:view];
    }
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
}
- (IBAction)cancelButtonAction:(id)sender {
    [alphaView removeFromSuperview];
}
- (IBAction)doneButtonAction:(id)sender {
    [self.delegate selectingDatePicker:date];
    [alphaView removeFromSuperview];
}
@end

