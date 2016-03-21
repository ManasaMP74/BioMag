#import "ShowDetailOfCriticalInfoViewController.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "Constant.h"
#import <MCLocalization/MCLocalization.h>
#import "CriticalTreatmentInfoViewController.h"
#import "MBProgressHUD.h"
#import "CriticalImageModel.h"
#import "UIImageView+AFNetworking.h"
@interface ShowDetailOfCriticalInfoViewController () <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,DeleteCriticalImageProtocol>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descritionLabel;
@property (weak, nonatomic) IBOutlet UIButton *EditButton;
@end

@implementation ShowDetailOfCriticalInfoViewController
{
    NSMutableArray *criticalImageArray;
    Postman *postman;
    NSString *noChangesToSave,*imageUploadFailed;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postman=[[Postman alloc]init];
    _EditButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _EditButton.titleLabel.numberOfLines = 2;
    [self layerOfTV];
    [self localize];
    [self navigationItemMethod];
    criticalImageArray=[[NSMutableArray alloc]init];
    _collectionviewHeight.constant=0;
    [self getDetailOfSharedTreatmentInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
-(void)textViewDidChange:(UITextView *)textView{
    if (textView==_summaryTextView) {
        if (_summaryTextView.text.length!=0) {
            _summaryLabel.hidden=YES;
        }else  _summaryLabel.hidden=NO;
    }if (textView==_descriptionTextView) {
        if (_descriptionTextView.text.length!=0) {
            _descritionLabel.hidden=YES;
        }else _descritionLabel.hidden=NO;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView==_summaryTextView) {
        if (textView.text.length==100) {
            return NO;
        }else return YES;
    }else return YES;
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
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

//localize
-(void)localize
{
    self.title=[MCLocalization stringForKey:@"Share Critical Treatment Info"];
    [_EditButton setTitle:[MCLocalization stringForKey:@"Edit"] forState:normal];
    _descritionLabel.text=[MCLocalization stringForKey:@"Add description"];
    _summaryLabel.text=[MCLocalization stringForKey:@"Add summary (100 Characters)"];
    noChangesToSave=[MCLocalization stringForKey:@"No changes is there to save"];
    imageUploadFailed=[MCLocalization stringForKey:@"Image upload failed"];
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
    NSString *url=[NSString stringWithFormat:@"%@%@/%@",baseUrl,criticalTreatmentInfoUrl,_criticalInfoModel.code];
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
    critical.criticalInfoModel=_criticalInfoModel;
    critical.addedcriticalArray=criticalImageArray;
    [self.navigationController pushViewController:critical animated:YES];
}
-(void)deleteImage{
    [self getDetailOfSharedTreatmentInfo];
}
@end
