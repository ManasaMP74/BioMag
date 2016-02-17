#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "customFont.h"

@interface Constant : customFont
-(NSAttributedString*)textFieldPlaceHolderText:(NSString *)text;
-(void)spaceAtTheBeginigOfTextField:(UITextField*)textField;
-(void)SetBorderForTextField:(UITextField*)textField;
-(void)SetBorderForLoginTextField:(UITextField*)textField;
-(void)setFontForHeaders:(UILabel*)label;
-(void)setFontForLabel:(UILabel*)label;
-(void)setFontFortextField:(UITextField*)text;
-(void)setFontForbutton:(UIButton*)button;
-(void)SetBorderForTextview:(UITextView*)textField;
-(void)setColorForLabel:(UILabel*)label;
-(NSAttributedString*)textFieldPlaceLogin:(NSString *)text;
-(void)setFontbold:(UITextField*)text;
-(void)setFontSemibold:(UITextField*)text;
-(NSAttributedString*)textFieldPatient:(NSString *)text;
-(NSAttributedString*)PatientSheetPlaceHolderText:(NSString *)text;
- (NSMutableAttributedString *)setColoredLabelandStar:(NSString *)strplaceHolder;

@end
