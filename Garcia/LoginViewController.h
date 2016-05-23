#import <UIKit/UIKit.h>
#import "LanguageChanger.h"
#define NULL_CHECK(X) [X isKindOfClass:[NSNull class]]?nil:X
@interface LoginViewController : UIViewController<languageChangeForDelegat>
@property (weak, nonatomic) IBOutlet UIButton *rememberMe;

@end
