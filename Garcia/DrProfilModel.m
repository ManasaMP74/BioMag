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
     [coder encodeObject:self.addressDict forKey:@"addressDict"];
     [coder encodeObject:self.jsonDict forKey:@"jsonDict"];
     [coder encodeObject:self.FirstName forKey:@"FirstName"];
     [coder encodeObject:self.middleName forKey:@"middleName"];
     [coder encodeObject:self.lastName forKey:@"lastName"];
     [coder encodeObject:self.name forKey:@"name"];
     [coder encodeObject:self.roleCode forKey:@"roleCode"];
     [coder encodeObject:self.userTypeCode forKey:@"userTypeCode"];
     [coder encodeObject:self.companyCode forKey:@"companyCode"];
     [coder encodeObject:self.certificate forKey:@"certificate"];
     [coder encodeObject:self.experience forKey:@"experience"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
       self.idValue = [decoder decodeObjectForKey:@"idValue"];
        self.code = [decoder decodeObjectForKey:@"code"];
       self.genderCode = [decoder decodeObjectForKey:@"genderCode"];
        self.gendername= [decoder decodeObjectForKey:@"gendername"];
        self.DOB = [decoder decodeObjectForKey:@"DOB"];
        self.email= [decoder decodeObjectForKey:@"email"];
        self.ContactNo= [decoder decodeObjectForKey:@"ContactNo"];
        self.maritialStatus= [decoder decodeObjectForKey:@"maritialStatus"];
       self.addressDict= [decoder decodeObjectForKey:@"addressDict"];
        self.jsonDict= [decoder decodeObjectForKey:@"jsonDict"];
       self.FirstName= [decoder decodeObjectForKey:@"FirstName"];
        self.middleName= [decoder decodeObjectForKey:@"middleName"];
       self.lastName= [decoder decodeObjectForKey:@"lastName"];
       self.name= [decoder decodeObjectForKey:@"name"];
       self.roleCode= [decoder decodeObjectForKey:@"roleCode"];
        self.userTypeCode= [decoder decodeObjectForKey:@"userTypeCode"];
        self.companyCode= [decoder decodeObjectForKey:@"companyCode"];
       self.certificate= [decoder decodeObjectForKey:@"certificate"];
        self.experience= [decoder decodeObjectForKey:@"experience"];
    }
    return self;
}
@end
