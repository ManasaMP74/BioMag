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
#import "ScanPointModel.h"
#import "CorrespondingModelClass.h"
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
    [self callApiToGetSection];
    view.hidden=NO;
    view.center = alphaView.center;
//    allSections = [[NSMutableArray alloc] init];
//   // [self callApiToGetSection];
//    
//    SectionModel *section = [[SectionModel alloc] init];
//    section.title = @"Head";
//    section.scanpointArray = [self dummyPartModels];
//    [allSections addObject:section];
//    
//    section = [[SectionModel alloc] init];
//    section.title = @"Arm";
//    section.scanpointArray = [self dummyArmPartModels];
//    [allSections addObject:section];
//    
//    section = [[SectionModel alloc] init];
//    section.title = @"Leg";
//    section.scanpointArray = [self dummyLegPartModels];
//    [allSections addObject:section];
//    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
//    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//    [appDel.window addSubview:alphaView];
//    [constant spaceAtTheBeginigOfTextField:_visitTF];
//    if (_dummyData.count>0) {
//        _visitTF.text=_dummyData[2];
//        [_AddButton setTitle:_dummyData[1] forState:normal];
//        _settingHeaderLabel.text=_dummyData[0];
//    }
}
-(void)hide{
    [alphaView removeFromSuperview];
}
- (IBAction)add:(id)sender {
    if (addsection==nil)
        addsection=[[AddSection alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y,view.frame.size.width,146)];
    view.hidden=YES;
    addsection.allSections=allSections;
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
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,allScanpointsApi];
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
    for (NSDictionary *dict1 in [dict[@"ViewModels"]objectForKey:@"Section"]) {
            SectionModel *model=[[SectionModel alloc]init];
            model.title=dict1[@"Name"];
            model.code=dict1[@"Code"];
            model.scanpointArray=[self getAllScanpoint:dict1[@"Scanpoint"]];
        [allSections addObject:model];
        
        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
        [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [appDel.window addSubview:alphaView];
        [constant spaceAtTheBeginigOfTextField:_visitTF];
    }
}
-(NSArray*)getAllScanpoint:(NSArray*)scanpointArray{
    NSMutableArray *allScanpoint=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in scanpointArray) {
        ScanPointModel *model=[[ScanPointModel alloc]init];
        model.code=dict[@"Code"];
        model.title=dict[@"Name"];
        model.correspondingpairArray=[self getAllCorrespondingArray:dict[@"Correspondingpair"]];
        [allScanpoint addObject:model];
    }
    return allScanpoint;
}
-(NSArray*)getAllCorrespondingArray:(NSArray*)correspondingPoint{
    NSMutableArray *correspondingPointArray=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in correspondingPoint) {
        CorrespondingModelClass *model=[[CorrespondingModelClass alloc]init];
        model.code=dict[@"Code"];
        model.title=dict[@"Name"];
        [correspondingPointArray addObject:model];
    }
    return correspondingPointArray;
}
@end
