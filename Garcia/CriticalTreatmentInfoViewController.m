#import "CriticalTreatmentInfoViewController.h"

@interface CriticalTreatmentInfoViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descritionLabel;

@end

@implementation CriticalTreatmentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layerOfTV];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)layerOfTV{
    _summaryTextView.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
    _summaryTextView.layer.borderWidth=1;
    _summaryTextView.layer.cornerRadius=5;
    _descriptionTextView.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
    _descriptionTextView.layer.borderWidth=1;
    _descriptionTextView.layer.cornerRadius=5;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView==_summaryTextView) {
        if (_summaryTextView.text.length!=0) {
            _summaryLabel.hidden=YES;
        }
    }if (textView==_descriptionTextView) {
        if (_descriptionTextView.text.length!=0) {
            _descritionLabel.hidden=YES;
        }
    }
}
@end
