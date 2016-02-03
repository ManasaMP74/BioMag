#import <Foundation/Foundation.h>

@interface DummyModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSArray *symptomTagArray;
@property (strong, nonatomic) NSArray *selectedIndexArray;
@property (strong, nonatomic) NSArray *selectedPreviousSittingDetailArray;
@property (strong, nonatomic) NSArray *selectedGermsArray;
@property (strong, nonatomic) NSArray *selectedGermsIndexArray;
@property (strong, nonatomic) NSArray *completeDetailToDrArray;
@end
