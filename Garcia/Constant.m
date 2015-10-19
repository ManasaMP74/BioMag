#import "Constant.h"

@implementation Constant
//textFieldPlaceHolder
-(NSAttributedString*)textFieldPlaceHolderText:(NSString *)text{
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    return str;
}
//Space At Beging of TextField
-(void)spaceAtTheBeginigOfTextField:(UITextField*)textField{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 44)];
    textField.leftView=view;
    textField.leftViewMode=3;
}
//setBorderForTextField
-(void)SetBorderForTextField:(UITextField*)textField{
    textField.layer.cornerRadius=15;
    textField.layer.borderColor=[UIColor blackColor].CGColor;
    textField.layer.borderWidth=1;
}
//setBorder For TextView
-(void)SetBorderForTextview:(UITextView*)textField{
    textField.layer.cornerRadius=15;
    textField.layer.borderColor=[UIColor blackColor].CGColor;
    textField.layer.borderWidth=1;
}
//set Font for Headers
-(void)setFontForHeaders:(UILabel*)label{
    label.font=[self customFont:OpenSansBold ofName:40];
    label.textColor=[UIColor blackColor];
}
//set Font for normal label
-(void)setFontForLabel:(UILabel*)label{
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=[UIColor lightGrayColor];
}
//set Font for textField
-(void)setFontFortextField:(UITextField*)text{
    text.font=[UIFont systemFontOfSize:14];
    text.textColor=[UIColor blackColor];
}
//set Font for button
-(void)setFontForbutton:(UIButton*)button{
    [button setTitleColor:[UIColor blackColor] forState:normal];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
}
@end
