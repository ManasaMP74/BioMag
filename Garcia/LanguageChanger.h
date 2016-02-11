//
//  LanguageChanger.h
//  Biomagnetism
//
//  Created by manasap on 11/02/16.
//  Copyright © 2016 manasap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageChanger : NSObject

-(void)callApiForLanguage:(NSString*)languageCode;
-(void)readingLanguageFromDocument:(NSString*)languageCode;


@end
