#import "SettingView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "AddSection.h"
#import "HexColors.h"
#import "SectionModel.h"
#import "PartModel.h"
#import "PostmanConstant.h"
#import "Postman.h"
#import "MBProgressHUD.h"
@implementation SettingView
{
    UIView *view;
    UIControl  *alphaView;
    Constant *constant;
    AddSection *addsection;
    NSMutableArray *allSections;
    DatePicker *datePicker;
    Postman *postman;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"SettingView" owner:self options:nil]lastObject];
    [self initializeView];
    [self addSubview:view];
    view.frame=self.bounds;
    postman=[[Postman alloc]init];
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
    [constant spaceAtTheBeginigOfTextField:_visitTF];
    if (_dummyData.count>0) {
        _visitTF.text=_dummyData[2];
        [_AddButton setTitle:_dummyData[1] forState:normal];
        _settingHeaderLabel.text=_dummyData[0];
    }
}
-(void)hide{
    [alphaView removeFromSuperview];
}

-(NSArray *)dummyPartModels
{
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    
    PartModel *part = [[PartModel alloc] init];
    part.title = @"Eye";
    part.allScanPoints = @[@"Eye Optic Nerve", @"Opposite Eye",@"Cerebellum",@"Cornea",@"Retina"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Thyroid";
    part.allScanPoints = @[@"Cheekbone", @"Liver",@"Adrenal Glands",@"Pyramidal Lobe",@"Thyroid Cartilage"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Inter Ciliary";
    part.allScanPoints = @[@"Medulla Oblongata", @"Kidney",@"Sacrum"];
    [mut addObject:part];
    
    return mut;
}

-(NSArray *)dummyArmPartModels
{
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    
    PartModel *part = [[PartModel alloc] init];
    part.title = @"Triceps of Arm";
    part.allScanPoints = @[@"Lesser Trochanter", @"Triceps of Arm"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Brachial Plexus";
    part.allScanPoints = @[@"Artery", @"Bursae"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Palm";
    part.allScanPoints = @[@"Palm", @"Bladder",@"Thigh"];
    [mut addObject:part];
    
    return mut;
}
-(NSArray *)dummyLegPartModels
{
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    
    PartModel *part = [[PartModel alloc] init];
    part.title = @"Waist";
    part.allScanPoints = @[@"Waist"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Sacrum";
    part.allScanPoints = @[@"Waist", @"Bladder"];
    [mut addObject:part];
    
    part = [[PartModel alloc] init];
    part.title = @"Lesser Trochanter";
    part.allScanPoints = @[@"Greater Trochanter", @"Kidney"];
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
        datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(view.frame.origin.x+50,view.frame.origin.y,view.frame.size.width-100,230)];
    datePicker.datePicker.minimumDate=[NSDate date];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
-(void)selectingDatePicker:(NSString *)date{
    [constant spaceAtTheBeginigOfTextField:_visitTF];
    _visitTF.text=date;
}
-(void)callApiToGetSection{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,anotomicalPoint];
    [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectOfSection:responseObject];
        [MBProgressHUD hideHUDForView:alphaView animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD hideHUDForView:alphaView animated:YES]; 
    }];
    
}
-(void)processResponseObjectOfSection:(id)responseObject{
    NSDictionary *dict=responseObject;
    for (NSDictionary *dict1 in dict[@"ViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            
        }
        
    }
}
@end
