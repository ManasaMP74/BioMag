#import "PostmanConstant.h"
@implementation PostmanConstant
NSString *const baseUrl=@"http://prithiviraj.vmokshagroup.com:8033/api/";
NSString *const getGender=@"gender";
NSString *const getMartialStatus=@"maritalstatus";
NSString *const getPatientList=@"userdetails";
NSString *const logIn=@"account/Authenticate";
NSString *const addPatient=@"/patient/0";
NSString *const editPatient=@"/patient/";
NSString *const addSymptomTag=@"symptomtag/";
NSString *const getSymptomTag=@"symptomtag";
NSString *const updateSymptomTag=@"symptomtag/";
NSString *const getProfile=@"DownloadDoc/";
NSString *const uploadFile=@"upload";
NSString *const allScanpointsApi=@"AnatomicalDetails";
NSString *const addTreatmentUrl=@"treatmentrequest/0";
NSString *const getTreatmentDetail=@"treatmentrequest/";
NSString *const closeTreatmentDetail=@"treatmentrequest/";
NSString *const biomagneticMatrix=@"anatomicalbiomagneticmatrixorderbyrank";
NSString *const germsUrl=@"germs";
NSString *const getTitleOfTreatment=@"partialtreatmentrequest";
@end
