#import "CriticalTreatmentInfoViewController.h"
#import <MCLocalization/MCLocalization.h>
#import "CriticalTreatmentInfoCollectionViewCell.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "ImageUploadAPI.h"
#import "CriticalImageModel.h"
#import "UIImageView+AFNetworking.h"
@interface CriticalTreatmentInfoViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,deleteCellProtocol>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descritionLabel;
@property (weak, nonatomic) IBOutlet UILabel *Label;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@end

@implementation CriticalTreatmentInfoViewController
{
    NSMutableArray *criticalImageArray;
    Postman *postman;
    NSString *noChangesToSave,*imageUploadFailed,*deleteImageStr,*yesStr,*noStr,*alert,*alertOk;
    ImageUploadAPI *imageManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postman=[[Postman alloc]init];
    [self layerOfTV];
    [self localize];
     [self navigationItemMethod];
    criticalImageArray =[[NSMutableArray alloc]init];
    imageManager=[[ImageUploadAPI alloc]init];
    [criticalImageArray addObjectsFromArray:_addedcriticalArray];
    if (criticalImageArray.count>0) {
        _collectionviewHeight.constant=128;
        [_collectionView reloadData];

    }
    else  _collectionviewHeight.constant=0;
    if (_summary.length>0) {
        _summaryLabel.hidden=YES;
        _summaryTextView.text=_summary;
    }
    if (_descriptionvalue.length>0) {
        _descritionLabel.hidden=YES;
        _descriptionTextView.text=_descriptionvalue;
    }

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
    [_cancelButton setTitle:[MCLocalization stringForKey:@"Cancel"] forState:normal];
    [_saveButton setTitle:[MCLocalization stringForKey:@"Save"] forState:normal];
    _descritionLabel.text=[MCLocalization stringForKey:@"Add description"];
     _summaryLabel.text=[MCLocalization stringForKey:@"Add summary (100 Characters)"];
    noChangesToSave=[MCLocalization stringForKey:@"No changes is there to save"];
   imageUploadFailed=[MCLocalization stringForKey:@"Image upload failed"];
    deleteImageStr =[MCLocalization stringForKey:@"Do you want to delete Image?"];
    yesStr=[MCLocalization stringForKey:@"Yes"];
    noStr=[MCLocalization stringForKey:@"No"];
    alert=[MCLocalization stringForKey:@"Alert!"];
    alertOk=[MCLocalization stringForKey:@"AlertOK"];
}
- (IBAction)camera:(id)sender {
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
    picker.delegate=self;
}
- (IBAction)addImage:(id)sender {
    UIImagePickerController *imgpick=[[UIImagePickerController alloc]init];
    imgpick.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:imgpick animated:YES completion:nil];
    imgpick.delegate=self;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    CriticalImageModel *model=[[CriticalImageModel alloc]init];
    model.selectedImage=image;
    [criticalImageArray addObject:model];
    _collectionviewHeight.constant=128;
    [_collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return criticalImageArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CriticalTreatmentInfoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CriticalImageModel *model=criticalImageArray[indexPath.row];
    if (model.storageId.length>0) {
        NSString *strimageUrl;
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            strimageUrl = [NSString stringWithFormat:@"%@%@%@/%@",baseUrlAws,dbName,model.storageId,model.fileName];
        }
        [cell.treatmentImageView setImageWithURL:[NSURL URLWithString:strimageUrl] placeholderImage:[UIImage imageNamed:@"default-placeholder"] ];
    }
  else  cell.treatmentImageView.image=model.selectedImage;
    cell.delegate=self;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
-(void)deleteCell:(UICollectionViewCell *)cell{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alert message:deleteImageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:yesStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
        CriticalTreatmentInfoCollectionViewCell *cell1=(CriticalTreatmentInfoCollectionViewCell*)cell;
        NSIndexPath *i=[_collectionView indexPathForCell:cell1];
        CriticalImageModel *model=criticalImageArray[i.row];
        if (model.storageId.length>0) {
            [self callDeleteDocumentAPI:i withDocumentModel:model];
        }else{
            [criticalImageArray removeObjectAtIndex:i.row];
            if (criticalImageArray.count>0) {
                _collectionviewHeight.constant=128;
            }else _collectionviewHeight.constant=0;
            [_collectionView reloadData];
        }
    }];
    UIAlertAction *failure=[UIAlertAction actionWithTitle:noStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [alertView addAction:failure];
    [self presentViewController:alertView animated:YES completion:nil];
}
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    if (criticalImageArray.count>0) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (CriticalImageModel *model in criticalImageArray) {
            if (model.storageId.length==0) {
                [array addObject:model];
            }
        }
        if (array.count>0) {
             [self callApiToPostCriticalTreatmentInfo];
        }else  [self showToastMessage:noChangesToSave];
       
    }else{
        [self showToastMessage:noChangesToSave];
    }
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
//save profile
- (void)saveImage:(NSString*)code
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if (criticalImageArray.count>0) {
        int imagecount=0;
        for (CriticalImageModel *model in criticalImageArray) {
            if (model.storageId.length==0) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString* path = [documentsDirectory stringByAppendingPathComponent:@"EdittedProfile.jpeg" ];
            NSData* data = UIImageJPEGRepresentation(model.selectedImage,.5);
            [data writeToFile:path atomically:YES];
            if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
                NSString *type=@"NLB0H7";
                NSString *caption=@"";
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSString *docId=[defaults valueForKey:@"Id"];
                        [imageManager uploadUserForVzoneDocumentPath:path forRequestCode:code withType:type withText:caption withRequestType:@"TreatmentInfo" withUserId:docId onCompletion:^(BOOL success) {
                            if (success)
                            {
                                //if (imagecount==criticalImageArray.count-1) {
                                [MBProgressHUD hideHUDForView:self.view animated:NO];
                                [self.navigationController popViewControllerAnimated:YES];
                               // }else  [self incrementThevalue:imagecount];
                            }else
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:NO];
                                [self showToastMessage:imageUploadFailed];
                            }
                        }];
                    }else{
                        NSArray *type=@[@"NLB0H7"];
                        NSArray *caption=@[@""];
                            [imageManager uploadDocumentPath:path forRequestCode:code withDocumentType:type withText:caption withRequestType:@"Treatment" onCompletion:^(BOOL success) {
                                if (success)
                                {
                                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                                }else
                                {
                                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                                    [self showToastMessage:imageUploadFailed];
                                }
                            }];
                    }
            }
        }
    }
}
-(void)incrementThevalue:(int)imagecount{
    imagecount++;
}
//call api for critical info
-(void)callApiToPostCriticalTreatmentInfo{
    
    if ([_differOfAddOrEdit isEqualToString:@"add"]) {
        NSString *url=[NSString stringWithFormat:@"%@%@/0",baseUrl,criticalTreatmentInfoUrl];
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            NSString *parameter=[NSString stringWithFormat:@"{\"request\":{\"Summary\":\"%@\",\"Description\":\"%@\",\"Published\":false,\"Status\":\"1\",\"SortNumber\":\"1\",\"PublishedDocs\":\"\",\"DocSortNumber\":\"1\",\"UserID\":60069, \"MethodType\":\"POST\"}}",_summaryTextView.text,_descriptionTextView.text];
            [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self processResponseTopostCriticalInfo:responseObject withPostOrPut:@"post"];
                [MBProgressHUD hideHUDForView:self.view animated:NO];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
                [MBProgressHUD hideHUDForView:self.view animated:NO];
            }];
        }
    }else{
        NSString *url=[NSString stringWithFormat:@"%@%@/%@",baseUrl,criticalTreatmentInfoUrl,_criticalInfoModel.idvalue];
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *docid=[userDefault valueForKey:@"Id"];
            NSString *parameter=[NSString stringWithFormat:@"{\"request\":{\"Summary\":\"%@\",\"Description\":\"%@\",\"Published\":false,\"Status\":\"1\",\"SortNumber\":\"1\",\"PublishedDocs\":\"WE0UZ38PBI\",\"DocSortNumber\":\"1\",\"UserID\":%d,\"Id\":%d,\"MethodType\":\"PUT\" }}",_summaryTextView.text,_descriptionTextView.text,[docid intValue],[_criticalInfoModel.idvalue intValue]];
            [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [MBProgressHUD hideHUDForView:self.view animated:NO];
                [self processResponseTopostCriticalInfo:responseObject withPostOrPut:@"put"];
            } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
            }];
        }
    }
}
-(void)processResponseTopostCriticalInfo:(id)response withPostOrPut:(NSString*)str{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dic1=response;
        dict=dic1[@"aaData"];
    }else{
        dict=response;
    }
    if ([dict[@"Success"] intValue]==1) {
        if ([str isEqualToString:@"post"]) {
             [self saveImage:dict[@"Code"]];
        }else  [self saveImage:_criticalInfoModel.code];
    }else{
        [self showToastMessage:dict[@"Message"]];
    }
}
//api to delete doc
-(void)callDeleteDocumentAPI:(NSIndexPath*)index withDocumentModel:(CriticalImageModel*)uploadmodel{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *drid=[userDefault valueForKey:@"Id"];
    NSString *drName=[userDefault valueForKey:@"Name"];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,deleteDocumentUrl];
    NSString *parameter=[NSString stringWithFormat:@"{\"request\":{\"docid\":%@,\"fileid\":\"%@\",\"RequestId\":%d,\"RequestCode\":\"%@\",\"UserName\":\"%@\",\"AuditEventDescription\":\"Document(%@)Deleted\"}}",uploadmodel.idvalue,uploadmodel.storageId,[drid intValue],uploadmodel.requestCode,drName,uploadmodel.fileName];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self processDeleteDoc:responseObject withIndex:index];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSString *str=[NSString stringWithFormat:@"%@",error];
        [self showToastMessage:str];
    }];
}
//process delete doc
-(void)processDeleteDoc:(id)responseObject withIndex:(NSIndexPath*)index{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dict1=responseObject;
        dict=dict1[@"aaData"];
    }
    if ([dict[@"Success"]intValue]==1) {
        [criticalImageArray removeObjectAtIndex:index.row];
        [_collectionView reloadData];
        [self.delegate deleteImage];
        if (criticalImageArray.count>0) {
            _collectionviewHeight.constant=128;
        }
        else  _collectionviewHeight.constant=0;
        [self showToastMessage:dict[@"Message"]];
    }
    else [self showToastMessage:dict[@"Message"]];
}

@end
