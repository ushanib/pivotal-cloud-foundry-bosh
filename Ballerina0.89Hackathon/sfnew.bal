import org.wso2.ballerina.connectors.salesforcesoap;
import ballerina.lang.xmls;
import ballerina.lang.system;
import ballerina.lang.jsons;
import ballerina.lang.strings;
function main(string[] args) {
	xml soapResponse;
	xml[] headers = [];
	string username = args[1];
	string password = args[2];
	string loginurl = args[4];
	string soapver = args[5];
	string query = args[3];


 	salesforcesoap:ClientConnector sales = create salesforcesoap:ClientConnector(username, password, loginurl, soapver);

		xml queryOptions = xmls:parse("<urn:QueryOptions xmlns:urn=\"urn:partner.soap.sforce.com\"><urn:batchSize>1</urn:batchSize></urn:QueryOptions>");
		
		
	    headers = [queryOptions];
		soapResponse = salesforcesoap:ClientConnector.query(sales, headers, args[3]);
		system:println(xmls:toString(soapResponse));
	

	string Sfusername = xmls:getString(soapResponse, "/*:queryResponse/*:result/*:records/*:Username/text()");
		string SfProfileId = xmls:getString(soapResponse, "/*:queryResponse/*:result/*:records/*:ProfileId/text()");
		string SfName = xmls:getString(soapResponse, "/*:queryResponse/*:result/*:records/*:Name/text()");
		string SfLastName = xmls:getString(soapResponse, "/*:queryResponse/*:result/*:records/*:LastName/text()");
		string SfEmail = xmls:getString(soapResponse, "/*:queryResponse/*:result/*:records/*:Email/text()");
		
       json jsPayload = {"SFUser":{"Sfusername":"Sfusername", "SfProfileId":"SfProfileId", "SfName":"SfName", "SfEmail":"SfLastName", "SfEmail":"dummyVal"}};
		jsons:set(jsPayload, "$.SFUser.Sfusername", Sfusername);
		jsons:set(jsPayload, "$.SFUser.SfProfileId", SfProfileId);
		jsons:set(jsPayload, "$.SFUser.SfName", SfName);
		jsons:set(jsPayload, "$.SFUser.SfLastName", SfLastName);
		jsons:set(jsPayload, "$.SFUser.SfEmail", SfEmail);
		system:println(strings:valueOf(jsPayload)); 

}
        