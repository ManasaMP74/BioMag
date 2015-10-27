#import "Constant.h"

@implementation Constant
//textFieldPlaceHolder
-(NSAttributedString*)textFieldPlaceHolderText:(NSString *)text{
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:12 ofName:OpenSansRegular]}];
    return str;
}
-(NSAttributedString*)textFieldPlaceLogin:(NSString *)text{
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:18 ofName:OpenSansRegular]}];
    return str;
}
//Space At Beging of TextField
-(void)spaceAtTheBeginigOfTextField:(UITextField*)textField{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,10, 44)];
    textField.leftView=view;
    textField.leftViewMode=3;
}
//setBorderForTextField
-(void)SetBorderForTextField:(UITextField*)textField{
    textField.layer.cornerRadius=15;
    textField.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    textField.layer.borderWidth=1;
}

//setBorderForTextField
-(void)SetBorderForLoginTextField:(UITextField*)textField{
    textField.layer.cornerRadius=6;
    textField.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    textField.layer.borderWidth=1;
}
//setBorder For TextView
-(void)SetBorderForTextview:(UITextView*)textField{
    textField.layer.cornerRadius=15;
    textField.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
;
    textField.layer.borderWidth=1;
    textField.font=[self customFont:14 ofName:OpenSansSemibold];
    textField.textColor=[UIColor blackColor];

}
//set Font for Headers
-(void)setFontForHeaders:(UILabel*)label{
    label.font=[self customFont:17 ofName:OpenSansSemibold];
    label.textColor=[UIColor blackColor];
}
//set Font for normal label
-(void)setFontForLabel:(UILabel*)label{
    label.font=[self customFont:14 ofName:OpenSansSemibold];
    label.textColor=[UIColor colorWithRed:0.196 green:0.196 blue:0.196 alpha:1];
}
//set Color For Label for normal label
-(void)setColorForLabel:(UILabel*)label{
    label.font=[self customFont:13 ofName:OpenSansSemibold];
    label.textColor=[UIColor colorWithRed:.082 green:.706 blue:0.941 alpha:1];
}
//set Font for textField
-(void)setFontFortextField:(UITextField*)text{
    text.font=[self customFont:14 ofName:OpenSansSemibold];
    text.textColor=[UIColor blackColor];
}
//set Font for button
-(void)setFontForbutton:(UIButton*)button{
    [button setTitleColor:[UIColor blackColor] forState:normal];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
}
//setBold
-(void)setFontbold:(UITextField*)text{
    text.font=[self customFont:20 ofName:OpenSansBold];
}
@end
