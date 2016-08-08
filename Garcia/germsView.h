#import <UIKit/UIKit.h>
#import "GermsTableViewCell.h"
#import "VMEnvironment.h"
#import "CompleteAuthorModel.h"
@protocol sendGermsData<NSObject>
@optional
-(void)germsData:(NSArray*)germasData;
-(void)passAuthorData:(CompleteAuthorModel*)model;
@end
@interface germsView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *codeSymbolTF;
@property (strong, nonatomic) IBOutlet UITextField *codeFullNameTF;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightOfNewGermView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet GermsTableViewCell *customCell;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeight;
-(void)alphaViewInitialize;
@property (assign, nonatomic)CGFloat heightOfSuperView;
@property (strong, nonatomic) IBOutlet UIButton *germNewAddButton;
@property (strong, nonatomic) IBOutlet UIView *germNewAddView;
@property(weak,nonatomic)id<sendGermsData>delegateForGerms;
@property(strong,nonatomic)NSString *fromParentViewGermsString;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *codesLabel;

@property (strong, nonatomic)NSArray *completeGermsArray;
@property (strong, nonatomic)NSArray *completeAuthorArray;


@property(strong,nonatomic)NSString *differenceStringBetweenAuthorAndGerms;
@end
