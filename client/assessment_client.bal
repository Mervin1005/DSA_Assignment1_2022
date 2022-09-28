import ballerina/grpc;
import ballerina/io;

AssessmentClient ep = check new ("http://localhost:9080");
public string loggedID = "";

public function main() {
    LoginPage();
}

function readResponse(Create_courseStreamingClient create_courseStreamingClient) returns error? {
    string? result = check create_courseStreamingClient->receiveString();
    while !(result is ()) {
        io:println("Created course Code Received:", result);
        result = check create_courseStreamingClient->receiveString();
    }
}

function LoginPage() {

    io:println("");
    io:println("");

    io:println("         Welcome assessmentmanagement system               ");
    io:println("");
    io:println("------------------------------------------------------------");
    io:println("");
    io:println("");
     io:println("Please select your user profile: learner,administrator,assessor");
    
    string userID = io:readln("Please enter user profile: ");
    string password = io:readln("Please enter password: ");

    LoginResponse|grpc:Error? res = ep->login({userID: userID, password: password});

    if (res is grpc:Error) {
        io:println("Error logging in");
    } else if (res["success"] === true) {
        loggedID = userID;
        io:println("You are successfully logged in");

        if (res["profile"] == ADMINISTRATOR) {
            AdminLandingPage();
        } else if (res["profile"] == ASSESSOR) {
            AssessorLandingPage();
        } else {
            StudentLandingPage();
        }

    } else {
        io:println("Login failed! Invalid credentials.");
        io:print("Loggin in was not succeful, please make sure the user profile and password are correct")
        LoginPage();
    }
}

function AssessorLandingPage() {
    io:println("");
    io:println("");
    io:println("");
    io:println("      You are logged in as an Assessor Dashboard              ");
    io:println("");
    io:println("");
    io:println("1. Get unmarked assignments");
    io:println("2. Submit marks");
    io:println("3. Logout");
    io:println("");
    io:println("");
    string choice = io:readln("Enter choice 1-3: ");

    if (choice === "1") {
        GetAssignments();
    } else if (choice === "2") {
        SubmitMark();
    }else if (choice === "3") {
        loggedID = "";
        LoginPage();
    } else {
        io:println("Invalid input");
        AssessorLandingPage();
    }

}

function GetAssignments() {

    stream<Submission, grpc:Error?>|grpc:Error streamResult = ep->request_assignment({courseCode: "dsp", assignmentID: 200, assessorCode: "assessor"});
    if (streamResult is grpc:Error) {
        io:println("Error from Connector: " + streamResult.message() + " - ");
        return;
    } else {
        checkpanic streamResult.forEach(function(Submission submission) {
            io:println(submission);
        });
    }

    AssessorLandingPage();
}

function SubmitMark() {
    string mark = io:readln("Enter mark: ");
    string studentID = io:readln("Enter student ID: ");
    string courseID = io:readln("Enter course ID: ");
    string assignmentID = io:readln("Enter assignment ID: ");
    boolean|grpc:Error result = ep->submit_mark({
        mark: checkpanic float:fromString(mark),
        studentID: studentID,
        courseID: courseID,
        assignmentID: checkpanic int:fromString(assignmentID)
    });

    io:println(result);
    if (result is boolean) {
        if (result == true) {
            io:println("Marked assignment");
        } else {
            io:println("Failed to mark assignment");
        }
    }

    AssessorLandingPage();
}

function AdminLandingPage() {
    io:println("");
    io:println("");
    io:println("    You are logged in as Administrator  ");
    io:println("");
    io:println("****************************************");
    io:println("1. Create a course");
    io:println("2. Assign assessor for course");
    io:println("3. Create a user ");
    io:println("4. Logout");
    io:println("");
    io:println("");
    string choice = io:readln("Enter choice 1-4: ");

    if (choice === "1") {
        CreateCourseLandingPage();
    } else if (choice === "2") {
        AssignLandingPage();
    } else if (choice === "3") {
        CreateUserUI();
    } else if (choice === "4") {
        loggedID = "";
        LoginPage();
    } else {
        io:println("Invalid input");
        AdminLandingPage();
    }
}

function CreateCourseLandingPage() {
    Assignment[] assignments = [];
    CourseRequest[] courses = [];
    int count = 0;

    while (true) {
        string name = io:readln("Course name: ");
        string courseCode = io:readln("Course code: ");
        while (true) {
            string weight = io:readln("Enter Assignment weight or '0' to proceed: ");
            float floatWeight = checkpanic float:fromString(weight);

            count += 100;

            assignments.push({"weight": floatWeight, "id": count});
            
            if (weight === "0") {
                break;
            }
        }

        courses.push({name: name, assignments: assignments, courseCode: courseCode});
        string choice = io:readln("Enter '1' to create another course or '0' to proceed: ");
        if (choice === "0") {
            break;
        }
    }

    Create_courseStreamingClient|grpc:Error streamingClient = ep->create_course();

    if (streamingClient is grpc:Error) {
        io:println("Error from Connector: " + streamingClient.message() + " - ");
        return;
    } else {
        future<error?> f1 = start readResponse(streamingClient);

        foreach CourseRequest val in courses {
            io:println("Sent course details: ", val);
            checkpanic streamingClient->sendCourseRequest(val);
        }

        checkpanic streamingClient->complete();
        io:println("Closed stream");

        checkpanic wait f1;
    }

    AdminLandingPage();
}

function AssignLandingPage() {
    string courseID = io:readln("Course ID: ");
    string assessorID = io:readln("Assessor ID: ");

    boolean|grpc:Error result = ep->assign_course({courseCode: courseID, assessorCode: assessorID});

    if (result is boolean) {
        if (result) {
            io:println("Assessor assigned");
        } else {
            io:println("Failed to assign Assessor");
        }
    }

    AdminLandingPage();
}

function CreateUserUI() {
    io:println("");
    io:println("");
    io:println("");
    string userCode = io:readln("User identifier: ");
    string name = io:readln("Full name: ");
    io:println("What type of user are you creating?");
    io:println("1. Administrator");
    io:println("2. Assessor");
    io:println("3. Learner");
    string assessorID = io:readln("Select profile: ");

    Create_userStreamingClient|grpc:Error userStream = ep->create_user();

    if (userStream is grpc:Error) {
        io:println("Error from Connector: " + userStream.message() + " - ");
    } else {
        checkpanic userStream->sendUserRequest({userCode: userCode, name: name, profile: (assessorID === "1") ? ADMINISTRATOR : (assessorID === "2") ? ASSESSOR : LEARNER});
    }

    AdminLandingPage();
}





function StudentLandingPage() {
    io:println("");
    io:println("");
    io:println("");
    io:println("           You are logged in as Student            ");
    io:println("");
    io:println("");
    io:println("1. Submit an assignment");
    io:println("2. Register for a course");
    io:println("3. Logout");
    io:println("");
    io:println("");
    string choice = io:readln("Enter choice 1-3: ");

    if (choice === "1") {
        SubmitAssignment();
    } else if (choice === "2") {
        CourseRegister();
    } else if(choice === "3") {
        loggedID = "";
        LoginPage();
    }else {
        io:println("Invalid input");
        StudentLandingPage();
    }
}

function SubmitAssignment() {
    AssignmentRequest[] assignments = [];
    while true {
        string courseCode = io:readln("Course code: ");
        string assignmentID = io:readln("Assignment ID: ");
        string content = io:readln("Content: ");

        assignments.push({courseCode: courseCode, studentID: loggedID, assignmentID: checkpanic int:fromString(assignmentID), content: content});
        string choice = io:readln(" To submit another assignment Enter '1' or '0' to continue: ");
        if (choice == "0") {
            break;
        }
    }

    Submit_assignmentStreamingClient|grpc:Error streamingClient = ep->submit_assignment();

    if (streamingClient is grpc:Error) {
        io:println("Error from Connector: " + streamingClient.message() + " - ");
        return;
    } else {

        foreach AssignmentRequest val in assignments {
            checkpanic streamingClient->sendAssignmentRequest(val);
        }

        checkpanic streamingClient->complete();
        io:println("Closed stream");

        boolean|grpc:Error? response = streamingClient->receiveBoolean();

        if (response === true) {
            io:println("Assignment submitted successfully");
        } else {
            io:println("Failed to submit Assignment");
        }

    }

    StudentLandingPage();

}

function CourseRegister() {
    string[] courses = [];

    while (true) {
        string courseID = io:readln("Enter Course ID: ");

        courses.push(courseID);

        string choice = io:readln("Enter '1' to register for another course or '0' to proceed: ");
        if (choice == "0") {
            break;
        }
    }

    RegisterStreamingClient|grpc:Error registerStream = ep->register();

    if (registerStream is grpc:Error) {
        io:println("Error from Connector: " + registerStream.message() + " - ");
        return;
    } else {
        foreach string courseID in courses {

            checkpanic registerStream->sendRegister({courseID: courseID, userID: loggedID});
        }

        checkpanic registerStream->complete();
        boolean|grpc:Error? result = registerStream->receiveBoolean();

        if (result is boolean) {
            if (result) {
                io:println("Registered for courses");
            } else {
                io:println("Failed to register for courses");

            }
        }
    }

    StudentLandingPage();
}
