#import <UIKit/UIKit.h>
#import "AddSectionCell.h"
#import "SectionBodyDetails.h"
@protocol hidePreviousViewofSection<NSObject>
@optional
-(void)HideSection:(BOOL)status;
-(void)hideAllView;
@end


@interface AddSection : UIView <UITableViewDataSource,UITableViewDelegate,hidePreviousViewofSectionDetail>

@property (strong, nonatomic) IBOutlet UILabel *sectionHeaderLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet AddSectionCell *addsectionCell;
@property (strong, nonatomic) NSArray *allSections,*allScanPointsArray;
-(void)alphaViewInitialize;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic)id<hidePreviousViewofSection>delegate;

@property (strong, nonatomic)NSString *completed;
@end
