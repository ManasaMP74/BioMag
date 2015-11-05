#import "SettingView.h"
#import "Constant.h"
#import "AppDelegate.h"
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
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
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
    view.hidden=NO;
    if (_dummyData.count>0) {
        _settingHeaderLabel.text=_dummyData[0];
    }
    section = [[SectionModel alloc] init];
    section.title = @"Leg";
    section.allParts = [self dummyLegPartModels];
    [allSections addObject:section];
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
}

-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius =3;
    view.layer.masksToBounds  = YES;
     [constant spaceAtTheBeginigOfTextField:_visitTF];
    _noteView.layer.cornerRadius=7;
    _noteView.layer.masksToBounds  = YES;
    _notesTextView.layer.cornerRadius=5;
    _completedCheckBox.layer.cornerRadius=5;
    _visitTF.layer.cornerRadius=5;
    _AddButton.layer.cornerRadius=5;
    _intervalTF.layer.cornerRadius=5;
    _visitButton.layer.cornerRadius=5;
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
        addsection=[[AddSection alloc]initWithFrame:CGRectMake(view.frame.origin.x,view.frame.origin.y,view.frame.size.width,230)];
    view.hidden=YES;
    addsection.allSections=allSections;
    addsection.allScanPointsArray=(NSArray *)[self dummyPartModels];
    [addsection alphaViewInitialize];
    addsection.delegate=self;
}
-(void)HideSection:(BOOL)status{
    view.hidden=NO;
}
- (IBAction)completed:(id)sender {
    if (_completedCheckBox.currentImage) {
        [_completedCheckBox setImage:nil forState:normal];
    }
   else
   {
        [_completedCheckBox setImage:[UIImage imageNamed:@"Tick"] forState:normal];
    }
}
- (IBAction)datePicker:(id)sender {
    if(datePicker==nil)
        datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(view.frame.origin.x,view.frame.origin.y,view.frame.size.width,220)];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
-(void)selectingDatePicker:(NSString *)date{
   _visitTF.text=date;
}
-(void)hideAllView{
    [alphaView removeFromSuperview];
    if ([_completedCheckBox.currentImage isEqual:[UIImage imageNamed:@"Tick"]]) {
        [self.delegate incrementSittingCell:@"Yes"];
    }else [self.delegate incrementSittingCell:@"No"];
}
@end
