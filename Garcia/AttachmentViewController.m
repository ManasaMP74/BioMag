#import "AttachmentViewController.h"

@interface AttachmentViewController ()<UIImagePickerControllerDelegate>

@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView.image=_selectedImage;
    self.navigationItem.hidesBackButton=YES;
    [self navigationItemMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)okButton:(id)sender {
    [self.delegate selectedImage:_imageView.image];
 [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)navigationItemMethod{
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

@end
