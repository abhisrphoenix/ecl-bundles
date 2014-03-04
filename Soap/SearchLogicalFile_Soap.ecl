/**
SearchLogicalFiles_Soap - Function to make DFUQuery Soap call.

@author: Abhilash

@Description
The SearchLogicalFiles_Soap is a SOAP call designed to do a search on logical files
based on pattern.
The details include the Name,whther its a Super file,Zip file or a Key File(index),
Owner,RecordCount,Modified date,Totalsize,Cluster Name of the files.

Usage := SearchLogicalFiles_Soap(Url, FilePattern, [Owner], [firstN]);

@Paramters
The function accepts the following parameters

Url :- The ESP Url including the port eg.(https://10.199.11.12:8010)
FilePattern :- the pattern or actual name of the file for which details are required
Owner :- The owner of the file to narrow the search(Optional) 
firstN :- The number of requested results ,default is 100 (Optional)

The functionResult Usage will return the result required.

Info:- In ESP, The Search Logical Files uses 
DFUQuery and this function utilizes the same SOAP.

The WSDl for the DFUQuery Soap call be be viewed from

http:// 'Esp_Url' /WsDfu/DFUQuery?ver_=1.2&wsdl

**/

EXPORT Bundle := MODULE(Std.BundleBase)
   EXPORT Name       := 'SearchLogicalFiles_Soap';
   EXPORT Description   := 'Function to make DFUQuery Soap call';
   EXPORT Authors       := ['abhisrphoenix'];
   EXPORT License       := 'http://www.apache.org/licenses/LICENSE-2.0';
   EXPORT Copyright     := 'Use, Improve, Extend, Distribute';
   EXPORT DependsOn     := [];
   EXPORT Version       := '1.0.0';
 END; 
EXPORT SearchLogicalFiles_Soap (STRING IP,STRING FilePattern , STRING  owner = '', firstN=100) := FUNCTION

STRING URl := IP+'/WsDfu';


fName := FilePattern;


DFUInfoRequest := 
		RECORD, MAXLENGTH(100)
			STRING LogicalName{XPATH('LogicalName')} := fName;
			STRING Owner{XPATH('Owner')} := owner;
			INTEGER FirstN{XPATH('FirstN')} := firstN;
			
		END;

 ESPExceptions_Lay :=
		RECORD
				STRING                     Code{XPATH('Code'),MAXLENGTH(10)};
				STRING                     Audience{XPATH('Audience'),MAXLENGTH(50)};
				STRING                     Source{XPATH('Source'),MAXLENGTH(30)};
				STRING                     Message{XPATH('Message'),MAXLENGTH(200)};
		END;
DFULogicalFile :=  RECORD ,  MAXLENGTH(300)	
			STRING  Name{XPATH('Name'),MAXLENGTH(70)};
			Boolean isSuperfile{XPATH('isSuperfile')};
			Boolean isZipfile{XPATH('isZipfile')};
			Boolean IsKeyFile{XPATH('IsKeyFile')};
			STRING 	Owner{XPATH('Owner'),MAXLENGTH(20)};
			STRING 	RecordCount{XPATH('RecordCount'),MAXLENGTH(20)};
			STRING 	Modified{XPATH('Modified'),MAXLENGTH(20)};
			STRING 	Totalsize{XPATH('Totalsize'),MAXLENGTH(20)};
			STRING 	ClusterName{XPATH('ClusterName'),MAXLENGTH(20)};
			
		 
END;
DFULogicalFiles := RECORD, MAXLENGTH(300)
   DATASET(DFULogicalFile)  LogicalFiles{XPATH('DFULogicalFile'),maxcount(500)};
			

END;
		

DFUInfoResponse      := RECORD
	
                
                DATASET(ESPExceptions_Lay)    Exceptions{XPATH('Exceptions/ESPException'),maxcount(110)};
                DATASET(DFULogicalFiles)  LogicalFiles{XPATH('DFULogicalFiles'),maxcount(500)};
		
		
		
END;
DATASET DFUInfoSoapCall   :=   SOAPCALL(URl
				,'DFUQuery'
				,DFUInfoRequest
				,DFUInfoResponse
				,XPATH('DFUQueryResponse')
				);
	
	
DATASET(DFULogicalFile) logicalFiles :=  DFUInfoSoapCall.LogicalFiles.LogicalFiles;

RETURN logicalFiles;


END;