#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "customFont.h"

@interface Constant : customFont
-(NSAttributedString*)textFieldPlaceHolderText:(NSString *)text;
-(void)spaceAtTheBeginigOfTextField:(UITextField*)textField;
-(void)SetBorderForTextField:(UITextField*)textField;
-(void)setFontForHeaders:(UILabel*)label;
-(void)setFontForLabel:(UILabel*)label;
-(void)setFontFortextField:(UITextField*)text;
-(void)setFontForbutton:(UIButton*)button;
-(void)SetBorderForTextview:(UITextView*)textField;
@end
