/**
GetWorkUnitInfo_Soap - Function to make WUInfo Soap call.

@author: Abhilash

@Description
The GetWorkUnitInfo_Soap is a SOAP call designed to return the information about an available Workunit.
The Workunit details include the owner , cluster, job name, state ,query,
the source files included in the job and the result files produced as part of the job


Usage := GetWorkUnitInfo_Soap(Url, WUId);

@Paramters
The function accepts the following parameters

Url :- The ESP Url including the port eg.(https://10.199.11.12:8010)
WUId :- the Workunit Id for whic the details are requested


The functionResult Usage.State will return the current state of the workunit Id and 
Usage.jobname will return the job name available
Usage.Exceptions will return the exceptions occured.

Info:- In ESP, when we do an open workunit iD a SOAP call is  fired, which is 
WUInfo and this function utilizes the same SOAP.

The WSDl for the WUInfo Soap call be be viewed from

http:// 'Esp_Url' /WsWorkunits/WUInfo?ver_=1.47&wsdl

**/

EXPORT Bundle := MODULE(Std.BundleBase)
   EXPORT Name       := 'GetWorkUnitInfo_Soap';
   EXPORT Description     := 'Function to make WUInfo Soap call';
   EXPORT Authors       := ['abhisrphoenix'];
   EXPORT License       := 'http://www.apache.org/licenses/LICENSE-2.0';
   EXPORT Copyright     := 'Use, Improve, Extend, Distribute';
   EXPORT DependsOn     := [];
   EXPORT Version       := '1.0.0';
 END; 
EXPORT GetWorkUnitInfo_Soap(STRING EspUrl,  STRING WUId ) := FUNCTION


 WuinfoInRecord :=
	record, maxlength(100)
		string eclWorkunit{xpath('Wuid')} := WUId;//'W20130718-133620';
	end;

rESPExceptions	:=
RECORD
	string		Code{XPATH('Code'),maxlength(10)};
	string		Audience{XPATH('Audience'),maxlength(50)};
	string		Source{XPATH('Source'),maxlength(30)};
	string		Message{XPATH('Message'),maxlength(200)};
END;
srcFile := RECORD
	String FILEName {XPATH('Name')};
	String Cluster {XPATH('Cluster')};
	STRING RecCount {XPATH('Count')};
END; 


ResultFiles_Lay := RECORD

	INTEGER Seq {XPATH('Sequence')};
	String Values {XPATH('Value')};
	String Link {XPATH('Link')};
	String FileName {XPATH('FileName')};
	STRING XmlSchema {XPATh('XmlSchema')};
	
	
END;

WuinfoResponse	:= RECORD

	string	Owner{XPATH('Workunit/Owner'),maxlength(20)};
	string	Cluster{XPATH('Workunit/Cluster'),maxlength(20)};
	STRING Jobname{xpath('Workunit/Jobname'),maxlength(20)};
	STRING State{xpath('Workunit/State'),maxlength(20)};
	STRING Query{xpath('Workunit/Query'),maxlength(100)};
	dataset(srcFile) 	SrcFiles{xpath('Workunit/SourceFiles/ECLSourceFile')};
	dataset(rESPExceptions)		Exceptions{XPATH('Exceptions/ESPException'),maxcount(110)};
	dataset(ResultFiles_Lay) 	ResultFiles{xpath('Workunit/Results/ECLResult')};
END;


DATASET WuInfoSoapCall   :=   SOAPCALL(EspUrl+'/WsWorkunits/'
	,'WUInfo'
	, wuinfoInRecord
	,wuinfoResponse
	,XPATH('WUInfoResponse')
	);


RETURN WuInfoSoapCall;

END;

x := GetWorkUnitInfo_Soap('http://10.194.10.2:8010/','W20140211-162628');
x