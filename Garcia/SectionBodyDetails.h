#import <UIKit/UIKit.h>
#import "DetailsSection.h"
#import "SectionModel.h"
#import "PartModel.h"
#import "Child.h"
@protocol hidePreviousViewofSectionDetail<NSObject>
@optional
-(void)HideofSectionDetail:(BOOL)status;
-(void)hideAllView;
@end
@interface SectionBodyDetails : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *sectionHeaderLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITableView *ChildTableView;
@property (strong, nonatomic) IBOutlet DetailsSection *detailsSectionCell;
@property (strong, nonatomic) IBOutlet UILabel *bodyPartHeaderlabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bodyPartHeight;
@property (strong, nonatomic) IBOutlet UILabel *correspondPointLabel;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *listingElements;
@property (assign, nonatomic) BOOL showBodyPartLabel;
@property (strong, nonatomic) IBOutlet Child *childCell;
@property (weak, nonatomic) IBOutlet UIButton *mPrevBtn;
@property (weak, nonatomic) IBOutlet UIButton *mNxtbtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
-(void)alphaViewInitialize;
@property (strong, nonatomic) IBOutlet UILabel *saveLabel;
@property (strong, nonatomic) SectionModel *selectedSection;
@property(strong,nonatomic) PartModel *partModelObj;
@property (strong, nonatomic)Child *chiledSectionCell;
@property (weak, nonatomic)id<hidePreviousViewofSectionDetail>delegate;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@end
