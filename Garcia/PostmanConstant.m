#import "PostmanConstant.h"
#import <MCLocalization/MCLocalization.h>

@implementation PostmanConstant
NSString *const languageCode=@"en";

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
//NSString *const language=@"language";

//Vzone testing
//NSString *const baseUrlAws =@"https://s3-ap-northeast-1.amazonaws.com/";
//NSString *const dbName =@"biomag-tst.images.original/";
//NSString *const dbNameforResized =@"biomag-tst.images.resized/";
//NSString *const baseurl=@"http://prithiviraj.vmokshagroup.com:8089/";
//NSString *const postmanCompanyCode=@"A0I7LV";
//NSString *const aboutUs=@"search/configuration";
//NSString *const FAQurl=@"configurationview/AOO6FQ";
//NSString *const termsAndCondition=@"configurationview/MWUFJM";
//NSString *const privecyAndPolicy=@"configurationview/4XOSBX";


 
//Vzone Production API

//NSString *const baseUrl=@"http://biomagnetictherapy.us-west-2.elasticbeanstalk.com/";
//NSString *const postmanCompanyCode=@"VM001";
//NSString *const dbNameforResized =@"biomag.images.resized/";
//NSString *const dbName =@"biomag.images.original/";
//NSString *const baseUrlAws =@"https://s3-us-west-2.amazonaws.com/";
//NSString *const aboutUs=@"search/configuration";
//NSString *const FAQurl=@"configurationview/AOO6FQ";
//NSString *const termsAndCondition=@"configurationview/MWUFJM";
//NSString *const privecyAndPolicy=@"configurationview/4XOSBX";



//For Vzone API
NSString *const searchApi=@"search/patient/";
NSString *const getProfile=@"LoadThumbnailImage/";
NSString *const uploadFile=@"aws/upload";
NSString *const expandProfileImage=@"LoadFile/";
NSString *const getGender=@"search/gender";
NSString *const getMartialStatus=@"maritalstatus";
NSString *const getPatientList=@"userdetails";
NSString *const getPagingPatientList=@"GetUsersBasedOnNumbers";
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
NSString *const addGermsUrl=@"germs";
NSString *const getTitleOfTreatment=@"partialtreatmentrequest";
NSString *const kGET_SEED_URL=@"seed";
NSString *const allScanpointsApi=@"AnatomicalDetails";
NSString *const language=@"search/language";
NSString *const languageUILabel=@"search/UILabel/";
NSString *const preferredLanguage=@"PreferredLanguage/User";
NSString *const deleteDocumentUrl=@"aws/DeleteDocument";
NSString *const deleteSitting=@"BiomagneticSittingResult/Delete";
NSString *const criticalTreatmentInfoUrl=@"ShareTreatmentInfo";
NSString *const searchSaredCriticalInfo=@"Search/ShareTreatmentInfo";
NSString *const saveScanpoint=@"scanpoint";
NSString *const saveCorrespondingPair=@"correspondingpair";
NSString *const addAnatomicalPoints=@"AnatomicalBiomagneticMatrix";

NSString *const DifferMetirialOrVzoneApi=@"vzone";
@end
