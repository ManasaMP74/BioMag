#import "SettingView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "AddSection.h"
#import "HexColors.h"
#import "SectionModel.h"
#import "PartModel.h"

@implementation SettingView
{
    UIView *view;
    UIControl  *alphaView;
    Constant *constant;
    AddSection *addsection;
    NSMutableArray *allSections;
    DatePicker *datePicker;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"SettingView" owner:self options:nil]lastObject];
    [self initializeView];
    [self addSubview:view];
    view.frame=self.bounds;
    return self;
}
-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
}

-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    view.hidden=NO;
    view.center = alphaView.center;
    allSections = [[NSMutableArray alloc] init];
    
    SectionModel *section = [[SectionModel alloc] init];
    section.title = @"Head";
    section.allParts = [self dummyPartModels];
    [allSections addObject:section];
    
    section = [[SectionModel alloc] init];
    section.title = @"Arm";
    section.allParts = [self dummyArmPartModels];
    [allSections addObject:section];
    
    section = [[SectionModel alloc] init];
    section.title = @"Leg";
    section.allParts = [self dummyLegPartModels];
    [allSections addObject:section];
    
    
    
    
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
}
-(void)hide{
    [alphaView removeFromSuperview];
}

-(NSArray *)dummyPartModels
{
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    
    PartModel *part = [[PartModel alloc] init];
    part.title = @"Eye";
    part.allScanPoints = @[@"scan point 1", @"Scan point 2"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Lips";
    part.allScanPoints = @[@"Tounge Scan1", @"Teeth Scan2"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Ear";
    part.allScanPoints = @[@"Ear Scan", @"EarScan 2"];
    [mut addObject:part];
    
    return mut;
}

-(NSArray *)dummyArmPartModels
{
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    
    PartModel *part = [[PartModel alloc] init];
    part.title = @"Finger";
    part.allScanPoints = @[@"Finger point 1", @"Finger point 2"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Knee";
    part.allScanPoints = @[@"Knee Scan1", @"Knee Scan2"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Thumb";
    part.allScanPoints = @[@"Thumb Scan", @"Thumb 2"];
    [mut addObject:part];
    
    return mut;
}
-(NSArray *)dummyLegPartModels
{
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    
    PartModel *part = [[PartModel alloc] init];
    part.title = @"Toe";
    part.allScanPoints = @[@"Toe point 1", @"Toe point 2"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"LegFiger";
    part.allScanPoints = @[@"LegFiger Scan1", @"LegFiger Scan2"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"LegThumb";
    part.allScanPoints = @[@"LegThumb Scan", @"LegThumb 2"];
    [mut addObject:part];
    
    return mut;
}
- (IBAction)add:(id)sender {
    if (addsection==nil)
        addsection=[[AddSection alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y,view.frame.size.width,146)];
    view.hidden=YES;
    addsection.allSections=allSections;
    addsection.allScanPointsArray=(NSArray *)[self dummyPartModels];
    [addsection alphaViewInitialize];
    addsection.delegate=self;
}
-(void)HideSection:(BOOL)status{
    view.hidden=NO;
}
-(void)hideAllView{
    [alphaView removeFromSuperview];
    if (_completedSwitch) {
        [self.delegate incrementSittingCell:@"Yes"];
    }
   else [self.delegate incrementSittingCell:@"No"];
}
- (IBAction)datePicker:(id)sender {
    if(datePicker==nil)
        datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(view.frame.origin.x,view.frame.origin.y,view.frame.size.width,220)];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
-(void)selectingDatePicker:(NSString *)date{
    [constant spaceAtTheBeginigOfTextField:_visitTF];
    _visitTF.text=date;
}

@end
