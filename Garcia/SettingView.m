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
    self.settingHeaderLabel.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
    self.visitLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
    self.intervalLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
     self.notesLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
     self.completedLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
     self.sectionLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
     self.saveLabel.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
    self.AddButton.backgroundColor=[UIColor colorWithHexString:@"#9295CA"];
    self.SaveBtnClicked.backgroundColor=[UIColor colorWithHexString:@"#9295CA"];
    [self.AddButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
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
-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    [constant spaceAtTheBeginigOfTextField:_visitTF];
    [constant spaceAtTheBeginigOfTextField:_intervalTF];
    [constant setFontForbutton:_AddButton];
    [constant setFontFortextField:_visitTF];
    [constant setFontFortextField:_intervalTF];
    [constant setFontForHeaders:_settingHeaderLabel];
    [constant setFontForLabel:_sectionLabel];
    [constant setFontForLabel:_visitLabel];
    [constant setFontForLabel:_intervalLabel];
    [constant setFontForLabel:_completedLabel];
}
- (IBAction)add:(id)sender {
    if (addsection==nil)
        addsection=[[AddSection alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-50,503, 413)];
    addsection.allSections=allSections;
    addsection.allScanPointsArray=(NSArray *)[self dummyPartModels];
    [addsection alphaViewInitialize];
}
- (IBAction)completed:(id)sender {
}
@end
