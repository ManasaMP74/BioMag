#import "AttachmentViewController.h"

@interface AttachmentViewController ()<UIImagePickerControllerDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *addnoteLabel;
@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]]];
    [self navigationItemMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _textView.userInteractionEnabled=_textViewEnabled;
    _imageView.image=_selectedImage;
    if (!_textViewEnabled) {
        if ([_captionText isEqualToString:@""]) {
            _textView.hidden=YES;
            _addnoteLabel.hidden=YES;
        }
        else{
            _textView.hidden=NO;
            _textView.text=_captionText;
            _addnoteLabel.hidden=YES;
        }
    }else{
        _textView.text=@"";
        _textView.hidden=NO;
        _addnoteLabel.hidden=NO;
    }
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
    if ([textView.text isEqualToString:@""]) {
        _addnoteLabel.hidden=NO;
    }
    else _addnoteLabel.hidden=YES;
    if (textView.text.length + (text.length - range.length) > 150) {
        [self.view endEditing:YES];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Text should be less than 150" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    return textView.text.length + (text.length - range.length) <= 150;
}
- (IBAction)gesture:(id)sender {
    [self.view endEditing:YES];
}
@end
