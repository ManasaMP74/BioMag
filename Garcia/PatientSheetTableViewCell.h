#import <UIKit/UIKit.h>

@interface PatientSheetTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *dateImageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *timeImageView;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageValueLabel;

@end
