#import "PostmanConstant.h"
@implementation PostmanConstant

// testing
NSString *const baseUrl=@"http://prithiviraj.vmokshagroup.com:8033/api/";
NSString *const postmanCompanyCode=@"A0I7LV";

// production
//NSString *const baseUrl=@"http://garciaapi-dev.elasticbeanstalk.com/api/";
//NSString *const postmanCompanyCode=@"VM001";

// Staging
//NSString *const baseUrl=@"http://prithiviraj.vmokshagroup.com:8035/api/";
//NSString *const postmanCompanyCode=@"VM001";

NSString *const languageCode=@"en";
NSString *const getGender=@"gender";
NSString *const getMartialStatus=@"maritalstatus";
NSString *const getPatientList=@"userdetails";
NSString *const logIn=@"account/Authenticate";
NSString *const forgotPassword=@"account/forgotpassword";
NSString *const addPatient=@"/patient/0";
NSString *const editPatient=@"/patient/";
NSString *const addSymptomTag=@"symptomtag/";
NSString *const getSymptomTag=@"Symptomtag";
NSString *const updateSymptomTag=@"symptomtag/";
NSString *const getProfile=@"LoadThumbnailImage/";
NSString *const uploadFile=@"upload";
NSString *const allScanpointsApi=@"AnatomicalDetails";
NSString *const addTreatmentUrl=@"treatmentrequest/0";
NSString *const getTreatmentDetail=@"search/treatmentrequest";
NSString *const closeTreatmentDetail=@"treatmentrequest/";
NSString *const biomagneticMatrix=@"anatomicalbiomagneticmatrixorderbyrank";
NSString *const germsUrl=@"germs";
NSString *const getTitleOfTreatment=@"partialtreatmentrequest";
NSString *const expandProfileImage=@"LoadFile/";
NSString *const toxicDeficiencyType=@"toxicDeficiencyType";
NSString *const toxicDeficiencyDetail=@"ToxicDeficiency";
NSString *const kGET_SEED_URL=@"seed";
@end
