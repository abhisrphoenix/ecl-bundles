/**
GetFileDetails_Soap - Function to make DFUInfo Soap call.

@author: Abhilash

@Description
The GetFileDetails_Soap is a SOAP call designed to return the information about a logical file.
The details include the file name, size, record count, the workunit id ,the owner
and the job that created the file, the ECL parameter of the return value has the 
actual record structure (Layout) of the file.

Usage := GetFileDetails_Soap(Url, FileName, [Cluster]);

@Paramters
The function accepts the following parameters

Url :- The ESP Url including the port eg.(https://10.199.11.12:8010)
FileName :- the name of the file for which details are required
Cluster :- The cluster to which the file belongs (Optional) 

The functionResult Usage.FileDetail will return the result where 
Usage.Exceptions will return the exceptions occured.

Info:- In ESP, after the file search and click 'Details' from context menu a SOAP call is  fired, which is 
DFUInfo and this function utilizes the same SOAP.

The WSDl for the DFUInfo Soap call be be viewed from

http:// 'Esp_Url' /WsDfu/DFUInfo?ver_=1.2&wsdl

**/

EXPORT GetFileDetails_Soap(STRING EspUrl, STRING FileName ,STRING  Cluster = '') := FUNCTION

DFUInfoRequest := 
		RECORD, MAXLENGTH(200)
			STRING OpenLogicalName{XPATH('Name')} 	:= FileName;
			STRING Cluster{XPATH('Cluster')} := '';
		END;

 ESPExceptions_Lay :=
		RECORD
				STRING                     Code{XPATH('Code'),MAXLENGTH(10)};
				STRING                     Audience{XPATH('Audience'),MAXLENGTH(50)};
				STRING                     Source{XPATH('Source'),MAXLENGTH(30)};
				STRING                     Message{XPATH('Message'),MAXLENGTH(200)};
		END;
DFUFileDetail :=  RECORD ,  MAXLENGTH(300)	

			STRING  	Name{XPATH('Name'),MAXLENGTH(70)};
			STRING 		Filename{XPATH('Filename'),MAXLENGTH(20)};
			
			STRING 	Filesize {XPATH('Filesize'),MAXLENGTH(100)};
			STRING 	RecordSize {XPATH('RecordSize'),MAXLENGTH(20)};
			STRING 	RecordCount{XPATH('RecordCount'),MAXLENGTH(20)};
			STRING		Wuid{XPATH('Wuid'),MAXLENGTH(20)};
			STRING 		Cluster{XPATH('Cluster'),MAXLENGTH(20)};
			STRING 		Owner{XPATH('Owner'),MAXLENGTH(20)};
			STRING 		JobName{XPATH('JobName'),MAXLENGTH(40)};
			STRING		ECL{XPATH('Ecl'),MAXLENGTH(20)};
			STRING		Modified{XPATH('Modified'),MAXLENGTH(20)};
		 
END;
		

DFUInfoResponse      := RECORD
	
                
                DATASET(ESPExceptions_Lay)    Exceptions{XPATH('Exceptions/ESPException'),maxcount(110)};
                DATASET(DFUFileDetail)  FileDetail{XPATH('FileDetail'),maxcount(20)};
		
		
		
END;
DATASET DFUInfoSoapCall   :=   SOAPCALL(EspUrl+'/WsDfu'
				,'DFUInfo'
				,DFUInfoRequest
				,DFUInfoResponse
				,XPATH('DFUInfoResponse')
				);

RETURN DFUInfoSoapCall;

END;
