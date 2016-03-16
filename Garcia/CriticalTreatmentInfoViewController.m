#import "CriticalTreatmentInfoViewController.h"
#import <MCLocalization/MCLocalization.h>
#import "CriticalTreatmentInfoCollectionViewCell.h"
#import "Constant.h"
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    Constant *constant=[[Constant alloc]init];
    [constant changeSaveBtnImage:_addImageButton];
    [self layerOfTV];
    [self localize];
     [self navigationItemMethod];
    criticalImageArray =[[NSMutableArray alloc]init];
    _collectionviewHeight.constant=0;
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
    [_addImageButton setTitle:[MCLocalization stringForKey:@"Add image"] forState:normal];
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
    [criticalImageArray addObject:image];
    _collectionviewHeight.constant=128;
    [_collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return criticalImageArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CriticalTreatmentInfoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.treatmentImageView.image=criticalImageArray[indexPath.row];
    cell.delegate=self;
    return cell;
}
-(void)deleteCell:(UICollectionViewCell *)cell{
    CriticalTreatmentInfoCollectionViewCell *cell1=(CriticalTreatmentInfoCollectionViewCell*)cell;
    NSIndexPath *i=[_collectionView indexPathForCell:cell1];
    [criticalImageArray removeObjectAtIndex:i.row];
    if (criticalImageArray.count>0) {
        _collectionviewHeight.constant=128;
    }else _collectionviewHeight.constant=0;
    [_collectionView reloadData];
}
@end
