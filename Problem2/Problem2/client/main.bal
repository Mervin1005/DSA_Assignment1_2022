import ballerina/http;
import ballerina/io;

public function main() returns error? {
    // Creates a new client with the backend URL.
    final http:Client clientEndpoint = check new ("http://localhost:4000");

    check LoginUI(clientEndpoint);
}

function LoginUI(http:Client clientEndpoint) returns error? {
    io:println("************************************************************");
    io:println("***********Welcome to COVID-19 statistics updates***********");
    io:println("************************************************************");
    io:println("What would you like to do?");
    io:println("1. All COVID-19 statistics updates");
    io:println("2. Get Region's updates by their abbriviation");
    io:println("3. Update_statistics");
    io:println("4. Tested_cases");
    io:println("5. Deaths_cases");
    io:println("6. Confirmed_cases");
    io:println("************************************************************");
    string choice = io:readln("Enter choice 1-6: ");

    json resp;

    if (choice == "1") {
        resp = check clientEndpoint->post("/graphql", {query: "{ all { region cases active } }"});
        io:println(resp.toJsonString());
        
    } else if (choice == "2") {
        io:println("KHM_Khomas, OSH_ Oshana, OMU_ Omusati, HAR_ Hardap, KAE_Kavango East, ");
        io:println("KAW_Kavango West, ERO_Erongo, OTJ_Otjozondjupa, ZAM_Zabezi ");
        io:println("OMA_Omaheke, OHA_Ohangwena, OSK_Oshikoto, KUN_Kunene, KAR_Karas, ");
        string iso = io:readln("Enter ISO: ");
        resp = check clientEndpoint->post("/graphql", {query: "{ filter(isoCode: \"" + iso + "\" ) { region cases } }"});
        io:println(resp.toJsonString());

    } else if (choice == "3") {
        string iso = io:readln("Enter abbriviation: ");
        string cases = io:readln("Enter new cases: ");
        string deaths = io:readln("Enter deaths: ");
        string recovery = io:readln("Enter recoveries: ");
        string cofirmed = io:readln("Enter Confirmed cases: ");

        resp = check clientEndpoint->post("/graphql", {query: "mutation{ update(isoCode: \""+iso+"\", entry: {deaths: "+deaths+", recovered: "+recovery+", new_case: "+cases+"}) { region cases recovered deaths active } }"});
        io:println(resp.toJsonString());

    } else if  (choice == "4") {
        resp = check clientEndpoint->post("/graphql", {query: "{ all { region cases active } }"});
        io:println(resp.toJsonString());
        // Codes for the function


    } else if  (choice == "5") {
        // Codes for the function


    } else if (choice == "6") {
        // Codes for the function
        resp = check clientEndpoint->post("/graphql", {query: "{ all { region cases confirmed } }"});
        io:println(resp.toJsonString());
        string iso = io:readln("Enter abbriviation: ");
        string cases = io:readln("Enter new cases: ");
        string deaths = io:readln("Enter deaths: ");
        string recovery = io:readln("Enter recoveries: ");
        string cofirmed = io:readln("Enter Confirmed cases: ");
    }


    check LoginUI(clientEndpoint);

}
