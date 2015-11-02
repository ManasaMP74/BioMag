#import <UIKit/UIKit.h>

@interface PatientSheetTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageValueLabel;

@end
