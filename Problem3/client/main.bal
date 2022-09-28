import ballerina/http;
import ballerina/io;

public function main() returns error? {
    // Creates a new client with the backend URL.
    final http:Client clientEndpoint = check new ("http://localhost:8080");

    while (true) {
// GUI or the user interface 
        io:println(" ");
        io:println(" ");
        io:println(" ");
        io:println(" Welcome to student management record");
        io:println("--------------------------------------");
        io:println("1. *********   Create a new student       *********************");
        io:println("2. *********   Update student details       *******************");
        io:println("3. *********   Update students course details       ***********");
        io:println("4. *********   lookup a single student         ******************");
        io:println("5. *********   Fetch all students         ***********************");
        io:println("6. **********  Delete student             **************************");
        io:println("-----------------------------------------------------");
        string Selected = io:readln("Please select 1-6: ");

        if (Selected == "1") {
            string Student_Name = io:readln("Enter Student Name: ");
            string Student_No = io:readln("Enter student number: ");
            string Email_Address = io:readln("Enter Email Course: ");
            string Course = io:readln("Enter Course: ");

            json resp = check clientEndpoint->post("/create", {student_No: Student_No, Student_Name: Student_Name, Email_Address: Email_Address, Course: Course});
            io:println(resp.toJsonString()); // writing to a json file

            // update student details
        } else if (Selected == "2") {
            string student_No = io:readln("Enter student number: ");
            string Student_Name = io:readln("Enter Student_Name: ");
            string Email_Address = io:readln("Enter Email_Address: ");
            string Course = io:readln("Enter Course: ");

              io:println("Press enter to skip.");

            json resp = check clientEndpoint->put("/update", {student_No: student_No, Student_Name: Student_Name, Email_Address: Email_Address, Course: Course});
            io:println(resp.toJsonString());

            // update student course details
        } else if (Selected == "3") {
            string student_No = io:readln("Enter student number: ");
            string course = io:readln("Enter course code: ");

            json resp = check clientEndpoint->put("/course", {student_No: student_No, course: course});
            io:println(resp.toJsonString());

    //lookup a single student
        } else if (Selected == "4") {
            string student_No = io:readln("Enter student number: ");

            json resp = check clientEndpoint->get("/lookup?student_No=" + student_No);
            io:println(resp);

         //   Fetch all students
        } else if (Selected == "5") {
            json resp = check clientEndpoint->get("/all");
            io:println(resp);

        //Delete student

        } else if (Selected == "6") {
            string student_No = io:readln("Enter student number: ");
            json resp = check clientEndpoint->delete("/delete?student_No=" + student_No);
            io:println(resp);
        }
    }
}
