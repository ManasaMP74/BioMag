#import "ShowCriticalInfoViewController.h"
#import "ShowCriticalInfoListModel.h"
#import "CriticalTreatmentInfoViewController.h"
#import <MCLocalization/MCLocalization.h>
#import "ShowDetailOfCriticalInfoViewController.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "Constant.h"
#import "CriticalTreatmentInfoViewController.h"
#import "MBProgressHUD.h"
#import "CriticalImageModel.h"
#import "UIImageView+AFNetworking.h"
@interface ShowCriticalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,DeleteCriticalImageProtocol>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeight;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descritionLabel;
@property (weak, nonatomic) IBOutlet UIButton *EditButton;
@property (weak, nonatomic) IBOutlet UILabel *summaryHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionHeaderLabel;
@end

@implementation ShowCriticalInfoViewController
{
    NSMutableArray *completeCriticalDetailArray;
    NSMutableArray *criticalImageArray;
    Postman *postman;
    ShowCriticalInfoListModel *selectedCriticalModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    completeCriticalDetailArray =[[NSMutableArray alloc]init];
    _detailView.layer.cornerRadius=5;
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    postman=[[Postman alloc]init];
    _EditButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _EditButton.titleLabel.numberOfLines = 2;
      [self layerOfTV];
    criticalImageArray=[[NSMutableArray alloc]init];
    _collectionviewHeight.constant=0;
    _detailViewHeight.constant=330;
    [self navigationItemMethod];
    [self localize];
    [self getDetailOfCriticalInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)getDetailOfCriticalInfo{
    for (NSDictionary *dict in _CriticalInfoArray) {
        ShowCriticalInfoListModel *model=[[ShowCriticalInfoListModel alloc]init];
        model.idvalue=dict[@"Id"];
         model.code=dict[@"Code"];
         model.summary=dict[@"Summary"];
        [completeCriticalDetailArray addObject:model];
    }
    [_tableview reloadData];
    [_scrollView layoutIfNeeded];
    _tableviewHeight.constant=_tableview.contentSize.height;
    [self tableView:_tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return completeCriticalDetailArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    ShowCriticalInfoListModel *model=completeCriticalDetailArray[indexPath.row];
    label.text=model.summary;
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowCriticalInfoListModel *model=completeCriticalDetailArray[indexPath.row];
//    ShowDetailOfCriticalInfoViewController *critical=[self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetailOfCriticalInfoViewController"];
//    critical.criticalInfoModel=model;
//    [self.navigationController pushViewController:critical animated:YES];
    selectedCriticalModel=model;
    [self getDetailOfSharedTreatmentInfo];
}
- (IBAction)addCriticalInfo:(id)sender {
    CriticalTreatmentInfoViewController *critical =[self.storyboard instantiateViewControllerWithIdentifier:@"CriticalTreatmentInfoViewController"];
    critical.summary=@"";
    critical.descriptionvalue=@"";
     critical.differOfAddOrEdit=@"add";
    [self.navigationController pushViewController:critical animated:YES];
}
-(void)navigationItemMethod{
    UIImage* image = [UIImage imageNamed:@"Back button.png"];
    CGRect frameimg1 = CGRectMake(100, 0, image.size.width+30, image.size.height);
    UIButton *button=[[UIButton alloc]initWithFrame:frameimg1];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-25;
    self.navigationItem.leftBarButtonItems=@[negativeSpace,barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
     self.title=[MCLocalization stringForKey:@"Share Critical Treatment Info"];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)layerOfTV{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    _summaryTextView.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
    _summaryTextView.layer.borderWidth=1;
    _summaryTextView.layer.cornerRadius=5;
    _descriptionTextView.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
    _descriptionTextView.layer.borderWidth=1;
    _descriptionTextView.layer.cornerRadius=5;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return criticalImageArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *im=[cell viewWithTag:10];
    CriticalImageModel *model=criticalImageArray[indexPath.row];
    NSString *strimageUrl;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        strimageUrl = [NSString stringWithFormat:@"%@%@%@/%@",baseUrlAws,dbName,model.storageId,model.fileName];
    }
    [im setImageWithURL:[NSURL URLWithString:strimageUrl] placeholderImage:[UIImage imageNamed:@"default-placeholder"] ];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
//Toast Message
-(void)showToastMessage:(NSString*)msg{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.labelText=msg;
    hubHUD.labelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
}
-(void)getDetailOfSharedTreatmentInfo{
    NSString *url=[NSString stringWithFormat:@"%@%@/%@",baseUrl,criticalTreatmentInfoUrl,selectedCriticalModel.code];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseOfgetDetailOfSharedTreatmentInfo:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)processResponseOfgetDetailOfSharedTreatmentInfo:(id)responseObject{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dic1=responseObject;
        dict=dic1[@"aaData"];
    }else{
        dict=responseObject;
    }
    if ([dict[@"Success"] intValue]==1) {
        NSArray *ar=dict[@"ShareTreatment"];
        NSDictionary *dict1=ar[0];
        NSString *summary=dict1[@"Summary"];
        NSString *description=dict1[@"Description"];
        if (summary.length>0) {
            _summaryTextView.text=summary;
            _summaryLabel.hidden=YES;
            int i=self.view.frame.size.width-40;
            CGFloat labelHeight =[summary boundingRectWithSize:(CGSize){i,CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height;
            if (labelHeight>75) {
                _summaryTVHeight.constant=labelHeight+20;
            }
        }
        if (description.length>0) {
            _descriptionTextView.text=description;
            _descritionLabel.hidden=YES;
            int i=self.view.frame.size.width-40;
            CGFloat labelHeight =[description boundingRectWithSize:(CGSize){i,CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height;
            if (labelHeight>100) {
                _desTVHeight.constant=labelHeight+20;
            }
        }
        NSArray *ar1=dict1[@"DocDetails"];
        if (ar1.count>0) {
            _collectionviewHeight.constant=128;
            _detailViewHeight.constant=469;
        }
        [criticalImageArray removeAllObjects];
        for (NSDictionary *dict2 in ar1) {
            CriticalImageModel *model=[[CriticalImageModel alloc]init];
            model.storageId=dict2[@"StorageID"];
            model.idvalue=dict2[@"ID"];
            model.code=dict2[@"Code"];
            model.fileName=dict2[@"FileName"];
            model.requestCode=dict2[@"RequestCode"];
            [criticalImageArray addObject:model];
        }
        [_collectionView reloadData];
    }
}
- (IBAction)editButton:(id)sender {
    CriticalTreatmentInfoViewController *critical=[self.storyboard instantiateViewControllerWithIdentifier:@"CriticalTreatmentInfoViewController"];
    critical.delegate=self;
    critical.summary=_summaryTextView.text;
    critical.descriptionvalue=_descriptionTextView.text;
    critical.differOfAddOrEdit=@"edit";
    critical.criticalInfoModel=selectedCriticalModel;
    critical.addedcriticalArray=criticalImageArray;
    [self.navigationController pushViewController:critical animated:YES];
}
-(void)deleteImage{
    [self getDetailOfSharedTreatmentInfo];
}
-(void)localize{
    [_criticalInfoLabel setTitle:[MCLocalization stringForKey:@"Critical TreatmentInfo"] forState:normal];
    [_addCriticalInfo setTitle:[MCLocalization stringForKey:@"Add Critical TreatmentInfo"] forState:normal];
    [_EditButton setTitle:[MCLocalization stringForKey:@"Edit"] forState:normal];
    _descritionLabel.text=[MCLocalization stringForKey:@"Add description"];
    _summaryLabel.text=[MCLocalization stringForKey:@"Add summary (100 Characters)"];
    _descriptionHeaderLabel.text=[MCLocalization stringForKey:@"Description"];
    _summaryHeaderLabel.text=[MCLocalization stringForKey:@"Summary"];
}
@end
