#import "AttachmentViewController.h"
#import "Constant.h"
#import <MCLocalization/MCLocalization.h>
@interface AttachmentViewController ()<UIImagePickerControllerDelegate,UITextViewDelegate>


@end

@implementation AttachmentViewController
{
 Constant *constant;
NSString * navTitle,*alert,*alertOk,*TextShouldBeLessThan150;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-2.jpg"]]];
    [self navigationItemMethod];
    constant=[[Constant alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _textView.userInteractionEnabled=_textViewEnabled;
    _imageView.image=_selectedImage;
    _textView.text=_captionText;
    if (_captionText!=nil) {
        _addNoteLabel.hidden=YES;
    }else _addNoteLabel.hidden=NO;
    if (_textViewEnabled==NO) {
        _textView.backgroundColor=[UIColor lightGrayColor];
        _okButton.hidden=YES;
        _CancelButton.hidden=YES;
    }else{
        _okButton.hidden=NO;
        _CancelButton.hidden=NO;
        _textView.backgroundColor=[UIColor whiteColor];
    }
    [constant changeSaveBtnImage:_okButton];
    [constant changeCancelBtnImage:_CancelButton];
}
- (IBAction)okButton:(id)sender {
    [self.delegate selectedImage:_imageView.image withCaption:_textView.text];
    _textView.text=nil;
 [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)navigationItemMethod{
    self.title=navTitle;
    _textView.layer.cornerRadius=5;
    _textView.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
    _textView.layer.borderWidth=1;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10,10, 10);
    UIImage* image = [UIImage imageNamed:@"Back button.png"];
    CGRect frameimg1 = CGRectMake(100, 0, image.size.width+30, image.size.height);
    UIButton *button=[[UIButton alloc]initWithFrame:frameimg1];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-25;
    self.navigationItem.leftBarButtonItems=@[barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        if (textView.text.length + (text.length - range.length) > 150) {
        [self.view endEditing:YES];
        UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alert message:TextShouldBeLessThan150 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:alertOk style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
           [alertView dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertView addAction:cancel];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    return textView.text.length + (text.length - range.length) <= 150;
}
-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        _addNoteLabel.hidden=NO;
    }
    else _addNoteLabel.hidden=YES;
}
- (IBAction)gesture:(id)sender {
    [self.view endEditing:YES];
}
//localization
-(void)localize{
    navTitle=[MCLocalization stringForKey:@"Attachment Sheet"];
    alert=[MCLocalization stringForKey:@"Alert!"];
    alertOk=[MCLocalization stringForKey:@"AlertOK"];
    TextShouldBeLessThan150=[MCLocalization stringForKey:@"Text should be less than 150"];
}
@end
