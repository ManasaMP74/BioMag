#import "AttachmentView.h"
#import "AppDelegate.h"
@implementation AttachmentView
{
    UIView *view;
    UIControl  *alphaView;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"AttachmentView" owner:self options:nil]lastObject];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
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
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
}
-(void)hide{
    [alphaView removeFromSuperview];
}
- (IBAction)takePic:(id)sender {
    [self.delegate throughCamera];
    [self hide];
}
- (IBAction)takePicFromAlbum:(id)sender {
    [self.delegate throughAlbum];
     [self hide];
}
@end
