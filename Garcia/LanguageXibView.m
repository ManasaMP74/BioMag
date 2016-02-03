#import "LanguageXibView.h"
#import "AppDelegate.h"
@implementation LanguageXibView
{
    UIView *view;
    UIControl  *alphaView;
    NSMutableArray *languageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
}
-(void)hide{
    [alphaView removeFromSuperview];
}
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return languageArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LanguageTableViewCell *cell = (LanguageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"LanguageXibCell" owner:self options:nil];
        cell =_customCell;
        _customCell = nil;
    }
    return cell;
}

@end
