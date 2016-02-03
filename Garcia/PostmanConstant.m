#import "PostmanConstant.h"
#import <MCLocalization/MCLocalization.h>
@implementation PostmanConstant

// Vzone API
NSString *const baseUrl=@"http://prithiviraj.vmokshagroup.com:8089/";
NSString *const postmanCompanyCode=@"A0I7LV";
NSString *const getProfile=@"LoadThumbnailImage/";
NSString *const uploadFile=@"upload";
NSString *const expandProfileImage=@"LoadFile/";


// Material API For Testing
//NSString *const baseUrl=@"http://prithiviraj.vmokshagroup.com:8033/api/";
//NSString *const postmanCompanyCode=@"VM001";
//NSString *const getProfile=@"LoadThumbnailImage/";
//NSString *const uploadFile=@"upload";
//NSString *const expandProfileImage=@"LoadFile/";


// production
//NSString *const baseUrl=@"http://garciaapi-dev.elasticbeanstalk.com/api/";
//NSString *const postmanCompanyCode=@"VM001";
//NSString *const getProfile=@"aws/LoadThumbnailImage/";
//NSString *const uploadFile=@"aws/upload";
//NSString *const expandProfileImage=@"aws/LoadFile/";

// Staging
//NSString *const baseUrl=@"http://prithiviraj.vmokshagroup.com:8035/api/";
//NSString *const postmanCompanyCode=@"VM001";

NSString *const languageCode=@"en";


//For Material API
//NSString *const getSymptomTag=@"Symptomtag";
//NSString *const toxicDeficiencyType=@"toxicDeficiencyType";
//NSString *const toxicDeficiencyDetail=@"ToxicDeficiency";
//NSString *const getGender=@"gender";
//NSString *const kGET_SEED_URL=@"seed";
//NSString *const allScanpointsApi=@"AnatomicalDetails";
//NSString *const addTreatmentUrl=@"treatmentrequest/0";
//NSString *const getTreatmentDetail=@"search/treatmentrequest";
//NSString *const closeTreatmentDetail=@"treatmentrequest/";
//NSString *const biomagneticMatrix=@"anatomicalbiomagneticmatrixorderbyrank";
//NSString *const germsUrl=@"germs";
//NSString *const getTitleOfTreatment=@"partialtreatmentrequest";
//NSString *const getMartialStatus=@"maritalstatus";
//NSString *const getPatientList=@"userdetails";
//NSString *const logIn=@"account/Authenticate";
//NSString *const forgotPassword=@"account/forgotpassword";
//NSString *const addPatient=@"patient/0";
//NSString *const editPatient=@"patient/";
//NSString *const addSymptomTag=@"symptomtag/";
//NSString *const updateSymptomTag=@"symptomtag/";
//NSString *const DifferMetirialOrVzoneApi=@"material";



//For Vzone API
NSString *const getGender=@"search/gender";
NSString *const getMartialStatus=@"maritalstatus";
NSString *const getPatientList=@"userdetails";
NSString *const logIn=@"account/Authenticate";
NSString *const forgotPassword=@"account/forgotpassword";
NSString *const addPatient=@"patient/0";
NSString *const editPatient=@"user/";
NSString *const addSymptomTag=@"symptomtag/";
NSString *const getSymptomTag=@"search/Symptomtag";
NSString *const updateSymptomTag=@"symptomtag/";
NSString *const toxicDeficiencyType=@"search/toxicDeficiencyType";
NSString *const toxicDeficiencyDetail=@"search/ToxicDeficiency";
NSString *const addTreatmentUrl=@"treatmentrequest";
NSString *const getTreatmentDetail=@"search/treatmentrequest";
NSString *const closeTreatmentDetail=@"treatmentrequest/";
NSString *const biomagneticMatrix=@"anatomicalbiomagneticmatrixorderbyrank";
NSString *const germsUrl=@"search/germs";
NSString *const getTitleOfTreatment=@"partialtreatmentrequest";
NSString *const kGET_SEED_URL=@"seed";
NSString *const allScanpointsApi=@"AnatomicalDetails";
NSString *const DifferMetirialOrVzoneApi=@"vzone";








//NSString *const alertOK=[MCLocalization stringForKey:@"AlertButtonOK"];



@end
