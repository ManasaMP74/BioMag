#import "DrProfilModel.h"

@implementation DrProfilModel
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.idValue forKey:@"idValue"];
    [coder encodeObject:self.code forKey:@"code"];
     [coder encodeObject:self.genderCode forKey:@"genderCode"];
     [coder encodeObject:self.gendername forKey:@"gendername"];
     [coder encodeObject:self.DOB forKey:@"DOB"];
     [coder encodeObject:self.email forKey:@"email"];
     [coder encodeObject:self.ContactNo forKey:@"ContactNo"];
     [coder encodeObject:self.maritialStatus forKey:@"maritialStatus"];
     [coder encodeObject:self.addressDict forKey:@"idValue"];
     [coder encodeObject:self.jsonDict forKey:@"idValue"];
     [coder encodeObject:self.FirstName forKey:@"idValue"];
     [coder encodeObject:self.middleName forKey:@"idValue"];
     [coder encodeObject:self.lastName forKey:@"idValue"];
     [coder encodeObject:self.name forKey:@"idValue"];
     [coder encodeObject:self.roleCode forKey:@"idValue"];
     [coder encodeObject:self.userTypeCode forKey:@"idValue"];
     [coder encodeObject:self.companyCode forKey:@"idValue"];
     [coder encodeObject:self.certificate forKey:@"idValue"];
     [coder encodeObject:self.experience forKey:@"idValue"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
  //      self.property = [decoder decodeObjectForKey:@"property"];
    }
    return self;
}
@end
