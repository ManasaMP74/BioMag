#import <UIKit/UIKit.h>
@protocol ExpandCellProtocol<NSObject>
@optional
-(void)expandCell:(UITableViewCell*)cell;
-(void)expandCellTOGetPreviousSitting:(UITableViewCell*)cell;
-(void)datePicker:(UITableViewCell*)cell withDate:(NSString*)date;
-(void)getGermsView:(UITableViewCell*)cell;
-(void)issueAndNoIssue:(UITableViewCell*)cell;
-(void)noteAddedDelegate:(UITableViewCell*)cell;
-(void)noteTappedDelegate:(UITableViewCell*)cell;
@end
@interface SittingTableViewCell : UITableViewCell<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *serialNumber;
@property (strong, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (strong, nonatomic) IBOutlet UILabel *correspondinPairLabel;
@property (strong, nonatomic) IBOutlet UILabel *germLabel;
@property (strong, nonatomic) IBOutlet UIButton *showGermsButton;
@property (strong, nonatomic) IBOutlet UIView *codeView;
@property (strong, nonatomic) IBOutlet UILabel *interpretation;
@property (strong, nonatomic) IBOutlet UILabel *psychoemotional;
@property (strong, nonatomic) IBOutlet UIImageView *doctorImage;
@property (strong, nonatomic) IBOutlet UILabel *doctorName;
@property (strong, nonatomic) IBOutlet UIButton *morePreviousButton;
@property (strong, nonatomic) IBOutlet UITextView *sittingTextView;
@property(weak,nonatomic)id<ExpandCellProtocol>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *expandButton;
@property (strong, nonatomic) IBOutlet UILabel *sittingNumber;
@property (strong, nonatomic) IBOutlet UILabel *sittingTvPlaceholder;
@property (strong, nonatomic) IBOutlet UICollectionView *previousDetailCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *sittingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousSittingBadgeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previousSittingBadgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *otherGermsLabel;
@property (weak, nonatomic) IBOutlet UIView *germView;

@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *previousSitting;
@property (weak, nonatomic) IBOutlet UILabel *addNoteLabel;
@property (weak, nonatomic) IBOutlet UITextView *addNoteTV;

@property (weak, nonatomic) IBOutlet UIButton *selectDeselectButton;

@end
