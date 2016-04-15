#import "Constant.h"

@implementation Constant
//textFieldPlaceHolder
-(NSAttributedString*)textFieldPlaceHolderText:(NSString *)text{
    if (text.length!=0) {
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:12 ofName:OpenSansRegular]}];
         return str;
    }
    else{
        NSAttributedString *str=[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:12 ofName:OpenSansRegular]}];
        return str;
    }
}
//textFieldPlaceHolder
-(NSAttributedString*)PatientSheetPlaceHolderText:(NSString *)text{
    
    
//    NSAttributedString *str=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:15 ofName:OpenSansRegular]}];
 if (text!=nil) {
     NSAttributedString *str=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7], NSFontAttributeName :[self customFont:15 ofName:OpenSansBold]}];
    //[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1]
    return str;
  }
else{
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:12 ofName:OpenSansRegular]}];
    return str;
}
}
//textFieldPlaceHolder
-(NSAttributedString*)textFieldPlaceLogin:(NSString *)text{
     if (text!=nil) {
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:18 ofName:OpenSansRegular]}];
    return str;
}
else{
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:12 ofName:OpenSansRegular]}];
    return str;
}
}
//textFieldPlaceHolder
-(NSAttributedString*)textFieldPatient:(NSString *)text{
     if (text!=nil) {
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.318 green:0.416 blue:0.463 alpha:0.3], NSFontAttributeName :[self customFont:16 ofName:OpenSansRegular]}];
    return str;
}
else{
    NSAttributedString *str=[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.333 green:0.329 blue:0.39 alpha:1], NSFontAttributeName :[self customFont:12 ofName:OpenSansRegular]}];
    return str;
}
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
    label.font=[self customFont:16 ofName:OpenSansBold];
    label.textColor=[UIColor colorWithRed:0.04 green:0.216 blue:.294 alpha:1];
}
//set Font for normal label
-(void)setFontForLabel:(UILabel*)label{
    label.font=[self customFont:14 ofName:OpenSansSemibold];
    label.textColor=[UIColor colorWithRed:0.192 green:0.196 blue:0.196 alpha:1];
}
//set Color For Label for normal label
-(void)setColorForLabel:(UILabel*)label{
    label.font=[self customFont:15 ofName:OpenSansSemibold];
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
//setSemiBold
-(void)setFontSemibold:(UITextField*)text{
    text.font=[self customFont:18 ofName:OpenSansSemibold];
}
// Star Redcolour Method
- (NSMutableAttributedString *)setColoredLabelandStar:(NSString *)strplaceHolder
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ *",strplaceHolder]];
    NSLog(@"%lu",(unsigned long)string.length);
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor redColor]
                   range:NSMakeRange(string.length-1,1)];
    
    
    return string;
    
}

//get the buttonImage
-(void)getTheAllSaveButtonImage:(UIButton*)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"Save-Button.png"] forState:normal];
    [btn setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:normal];
}
//change the save btn image size according to text
-(void)changeSaveBtnImage:(UIButton*)btn{
 [btn setBackgroundImage:[[UIImage imageNamed:@"Save-Button"] resizableImageWithCapInsets:(UIEdgeInsetsMake(12, 30, 12, 30))] forState:(UIControlStateNormal)];
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.titleLabel.numberOfLines = 2;
}
//change the cancel btn image size according to text
-(void)changeCancelBtnImage:(UIButton*)btn{
    [btn setBackgroundImage:[[UIImage imageNamed:@"Cancel-Button"] resizableImageWithCapInsets:(UIEdgeInsetsMake(12, 30, 12, 30))] forState:(UIControlStateNormal)];
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.titleLabel.numberOfLines = 2;
}





@end
