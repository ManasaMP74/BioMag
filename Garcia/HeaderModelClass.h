#import <Foundation/Foundation.h>

@interface HeaderModelClass : NSObject
@property (strong,nonatomic)NSString *sectionName;
@property (strong,nonatomic)NSString *sectionCode;
@property(strong,nonatomic)NSMutableArray *scanpointNameArray;
@property(strong,nonatomic)NSMutableArray *scanpointCodeArray;
@property (strong,nonatomic)NSMutableArray *correspondingPair;
@property(strong,nonatomic)NSArray *toxicDeficienceyDetail;
@end
