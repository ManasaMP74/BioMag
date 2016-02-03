#import "LanguageXib.h"
#import "AppDelegate.h"

@implementation LanguageXib
{
    UIView *view;
    UIControl  *alphaView;
    NSMutableArray *languageArray;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"LanguageView" owner:self options:nil]lastObject];
    [self addSubview:view];
    view.frame=self.bounds;
    languageArray=[[NSMutableArray alloc]init];
    [languageArray addObject:@"English"];
    return self;
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
