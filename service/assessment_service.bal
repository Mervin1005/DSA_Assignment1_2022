import ballerina/log;
import ballerina/grpc;

listener grpc:Listener ep = new (9080);

map<UserRequest> users = {
    "admin": {profile: ADMINISTRATOR, password: "admin"},
    "assessor": {profile: ASSESSOR, password: "assessor"},
    "learner": {profile: LEARNER, password: "learner"}
};


table<Submission> submissions = table [
        {
            courseCode: "dsp",
            assignmentID: 200,
            studentID: "learner1",
            content: "This problem focuses on a Restful API to manage a student record. A student is defined by a student number, a name, an email address and the courses the student took. For each course, there is the course code, the weights of the assessments in the course and the marks awarded for each assessment.",
            mark: 0.0,
            marked: false
        },
        {
            courseCode: "dsp",
            assignmentID: 200,
            studentID: "learner2",
            content: "Your task is to define the API following the OpenAPI standard and implement the client and service in the Ballerina language.",
            mark: 0.0,
            marked: false
        }
    ];

map<Course> courses = {
    "dsp": {
        code: "dsp",
        name: "Distributed Systems",
        assessor: "assessor",
        students: [],
        assignments: [
            {
                id: 200,
                weight: 0.6
            }
        ]
    }
};



@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_ASSESSMENT, descMap: getDescriptorMapAssessment()}
service "Assessment" on ep {

    // An administrator adds new courses and sets the number of assessments for each course and the assessment weights. 
    // He/she also assigns assessors to each course

    remote function create_course(AssessmentStringCaller caller, stream<CourseRequest, grpc:Error?> clientStream) returns error? {

        check clientStream.forEach(function(CourseRequest value) {
            log:printInfo("Received:", value = value);
            courses[value.courseCode] = {code: value.courseCode, name: value.name, assignments: value.assignments};

            log:printInfo(courses.toBalString());

            checkpanic caller->sendString(value.courseCode);
            log:printInfo("Sent:", value = value.courseCode);

        });

        log:printInfo("Closing stream");
        check caller->complete();
    }

   remote function login(LoginRequest value) returns LoginResponse|error {
        if (users.hasKey(value.userID)) {
            UserRequest? user = users[value.userID];

            if (user is UserRequest && user.password == value.password) {
                Profiles? profile = user["profile"];
                if (profile is Profiles) {
                    return {success: true, profile: profile};
                }
            }

        }
        return {success: false};
    }

    // The system has three user profiles: learner, administrator and assessor.
    remote function create_user(stream<UserRequest, grpc:Error?> clientStream) returns CreateUserResponse|error {
        CreateUserData[] result = [];

        check clientStream.forEach(function(UserRequest value) {
            if (users.hasKey(value.userCode)) {
                // user already exists
                result.push({userCode: value.userCode, status: "Failed, User already exists"});
            } else {
                value.password = "password";
                users[value.userCode] = value;
                result.push({userCode: value.userCode, status: "Created"});
            }
        });

        return {data: result};
    }

       //A learner registers for courses, submits assignments for each assessment of each course he/she registered for, and finally checks his/her result.

    remote function register(stream<Register, grpc:Error?> clientStream) returns boolean|error {

        check clientStream.forEach(function(Register value) {
            log:printInfo("Received:", value = value);

            string[]? ids = courses[value.courseID]["students"];
            if (ids is string[]) {
                ids.push(value.userID);
                courses[value.courseID]["students"] = ids;
            }
        });

        log:printInfo(courses.toJsonString());

        return true;
    }

    // learner submits one or several assignments for one or multiple courses he/she registered
    // for. The assignments are streamed to the server, and the response is received once the operation completes;
    remote function submit_assignment(stream<AssignmentRequest, grpc:Error?> clientStream) returns boolean|error {

        check clientStream.forEach(function(AssignmentRequest value) {
            submissions.add({studentID: value.studentID, content: value.content, assignmentID: value.assignmentID, courseCode: value.courseCode});
        });

        log:printInfo(submissions.toBalString());

        return true;
    }

 // assessor submits the marks for assignments
    remote function submit_mark(Mark value) returns boolean|error {
        log:printInfo("Checking....");
        foreach Submission submission in submissions {
            if (submission.assignmentID == value.assignmentID && submission.courseCode == value.courseID && submission.studentID == value.studentID && !submission.marked) {
                submission.mark = value.mark;
                submission.marked = true;
            }
        }

        log:printInfo(submissions.toBalString());

        return true;
    }

    // assessor requests submitted assignments for a course he/she has been allocated. 
    remote function request_assignment(AssessorRequest value) returns stream<Submission, error?> {

        Submission[] res = [];

        // Check if user is assessor
        if (courses[value.courseCode]["assessor"] == value.assessorCode) {
            log:printInfo("IS assessorCode ");

            foreach Submission submission in submissions {
                if (submission.assignmentID == value.assignmentID && submission.courseCode == value.courseCode && !submission.marked) {
                    res.push(submission);
                }
            }

        }

        return res.toStream();
    }

    // administrator assigns each created course to an assessor;
    remote function assign_course(AssignRequest value) returns boolean|error {
       
        courses[value.courseCode]["assessor"] = value.assessorCode;
        return true;
    }

}

