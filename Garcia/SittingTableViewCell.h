#import <UIKit/UIKit.h>
@protocol ExpandCellProtocol<NSObject>
-(void)expandCell:(UITableViewCell*)cell;
-(void)expandCellTOGetPreviousSitting:(UITableViewCell*)cell;
-(void)datePicker:(UITableViewCell*)cell withDate:(NSString*)date;
-(void)getGermsView:(UITableViewCell*)cell;
@end
@interface SittingTableViewCell : UITableViewCell<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *serialNumber;
@property (strong, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (strong, nonatomic) IBOutlet UILabel *correspondinPairLabel;

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
@end
