import ballerina/grpc;
import ballerina/protobuf.types.wrappers;

public isolated client class AssessmentClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_ASSESSMENT, getDescriptorMapAssessment());
    }

    isolated remote function assign_course(AssignRequest|ContextAssignRequest req) returns boolean|grpc:Error {
        map<string|string[]> headers = {};
        AssignRequest message;
        if req is ContextAssignRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Assessment/assign_course", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <boolean>result;
    }

    isolated remote function assign_courseContext(AssignRequest|ContextAssignRequest req) returns wrappers:ContextBoolean|grpc:Error {
        map<string|string[]> headers = {};
        AssignRequest message;
        if req is ContextAssignRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Assessment/assign_course", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function submit_mark(Mark|ContextMark req) returns boolean|grpc:Error {
        map<string|string[]> headers = {};
        Mark message;
        if req is ContextMark {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Assessment/submit_mark", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <boolean>result;
    }

    isolated remote function submit_markContext(Mark|ContextMark req) returns wrappers:ContextBoolean|grpc:Error {
        map<string|string[]> headers = {};
        Mark message;
        if req is ContextMark {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Assessment/submit_mark", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function login(LoginRequest|ContextLoginRequest req) returns LoginResponse|grpc:Error {
        map<string|string[]> headers = {};
        LoginRequest message;
        if req is ContextLoginRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Assessment/login", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <LoginResponse>result;
    }

    isolated remote function loginContext(LoginRequest|ContextLoginRequest req) returns ContextLoginResponse|grpc:Error {
        map<string|string[]> headers = {};
        LoginRequest message;
        if req is ContextLoginRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Assessment/login", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <LoginResponse>result, headers: respHeaders};
    }

    isolated remote function create_user() returns Create_userStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("Assessment/create_user");
        return new Create_userStreamingClient(sClient);
    }

    isolated remote function submit_assignment() returns Submit_assignmentStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("Assessment/submit_assignment");
        return new Submit_assignmentStreamingClient(sClient);
    }

    isolated remote function register() returns RegisterStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("Assessment/register");
        return new RegisterStreamingClient(sClient);
    }

    isolated remote function request_assignment(AssessorRequest|ContextAssessorRequest req) returns stream<Submission, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        AssessorRequest message;
        if req is ContextAssessorRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("Assessment/request_assignment", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        SubmissionStream outputStream = new SubmissionStream(result);
        return new stream<Submission, grpc:Error?>(outputStream);
    }

    isolated remote function request_assignmentContext(AssessorRequest|ContextAssessorRequest req) returns ContextSubmissionStream|grpc:Error {
        map<string|string[]> headers = {};
        AssessorRequest message;
        if req is ContextAssessorRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("Assessment/request_assignment", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        SubmissionStream outputStream = new SubmissionStream(result);
        return {content: new stream<Submission, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function create_course() returns Create_courseStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("Assessment/create_course");
        return new Create_courseStreamingClient(sClient);
    }
}

public client class Create_userStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUserRequest(UserRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUserRequest(ContextUserRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUserResponse() returns CreateUserResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUserResponse>payload;
        }
    }

    isolated remote function receiveContextCreateUserResponse() returns ContextCreateUserResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUserResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class Submit_assignmentStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendAssignmentRequest(AssignmentRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextAssignmentRequest(ContextAssignmentRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveBoolean() returns boolean|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <boolean>payload;
        }
    }

    isolated remote function receiveContextBoolean() returns wrappers:ContextBoolean|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <boolean>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class RegisterStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendRegister(Register message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextRegister(ContextRegister message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveBoolean() returns boolean|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <boolean>payload;
        }
    }

    isolated remote function receiveContextBoolean() returns wrappers:ContextBoolean|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <boolean>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class SubmissionStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Submission value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|Submission value;|} nextRecord = {value: <Submission>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class Create_courseStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendCourseRequest(CourseRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextCourseRequest(ContextCourseRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return payload.toString();
        }
    }

    isolated remote function receiveContextString() returns wrappers:ContextString|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: payload.toString(), headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class AssessmentBooleanCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBoolean(boolean response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBoolean(wrappers:ContextBoolean response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class AssessmentStringCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextString(wrappers:ContextString response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class AssessmentSubmissionCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSubmission(Submission response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSubmission(ContextSubmission response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class AssessmentLoginResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendLoginResponse(LoginResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextLoginResponse(ContextLoginResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class AssessmentCreateUserResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCreateUserResponse(CreateUserResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCreateUserResponse(ContextCreateUserResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextSubmissionStream record {|
    stream<Submission, error?> content;
    map<string|string[]> headers;
|};

public type ContextAssignmentRequestStream record {|
    stream<AssignmentRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextCourseRequestStream record {|
    stream<CourseRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextRegisterStream record {|
    stream<Register, error?> content;
    map<string|string[]> headers;
|};

public type ContextUserRequestStream record {|
    stream<UserRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextLoginResponse record {|
    LoginResponse content;
    map<string|string[]> headers;
|};

public type ContextSubmission record {|
    Submission content;
    map<string|string[]> headers;
|};

public type ContextMark record {|
    Mark content;
    map<string|string[]> headers;
|};

public type ContextLoginRequest record {|
    LoginRequest content;
    map<string|string[]> headers;
|};

public type ContextAssignmentRequest record {|
    AssignmentRequest content;
    map<string|string[]> headers;
|};

public type ContextCourseRequest record {|
    CourseRequest content;
    map<string|string[]> headers;
|};

public type ContextRegister record {|
    Register content;
    map<string|string[]> headers;
|};

public type ContextAssessorRequest record {|
    AssessorRequest content;
    map<string|string[]> headers;
|};

public type ContextCreateUserResponse record {|
    CreateUserResponse content;
    map<string|string[]> headers;
|};

public type ContextUserRequest record {|
    UserRequest content;
    map<string|string[]> headers;
|};

public type ContextAssignRequest record {|
    AssignRequest content;
    map<string|string[]> headers;
|};

public type LoginResponse record {|
    boolean success = false;
    Profiles profile = LEARNER;
|};

public type Submission record {|
    string studentID = "";
    string content = "";
    float mark = 0.0;
    boolean marked = false;
    string courseCode = "";
    int assignmentID = 0;
|};

public type Mark record {|
    int assignmentID = 0;
    float mark = 0.0;
    string studentID = "";
    string courseID = "";
|};

public type LoginRequest record {|
    string userID = "";
    string password = "";
|};

public type CreateUserData record {|
    string userCode = "";
    string status = "";
|};

public type AssignmentRequest record {|
    string courseCode = "";
    string studentID = "";
    string content = "";
    int assignmentID = 0;
|};

public type AssessorAssignments record {|
    AssignmentRequest[] Assignments = [];
|};

public type Assignment record {|
    int id = 0;
    float weight = 0.0;
|};

public type CourseRequest record {|
    string courseCode = "";
    string name = "";
    Assignment[] assignments = [];
|};

public type AssessorRequest record {|
    string courseCode = "";
    int assignmentID = 0;
    string assessorCode = "";
|};

public type Register record {|
    string userID = "";
    string courseID = "";
|};

public type CreateUserResponse record {|
    CreateUserData[] data = [];
|};

public type Course record {|
    string code = "";
    string name = "";
    Assignment[] assignments = [];
    string assessor = "";
    string[] students = [];
|};

public type UserRequest record {|
    string userCode = "";
    string name = "";
    Profiles profile = LEARNER;
    string password = "";
|};

public type AssignRequest record {|
    string courseCode = "";
    string assessorCode = "";
|};

public enum Profiles {
    LEARNER,
    ADMINISTRATOR,
    ASSESSOR
}

const string ROOT_DESCRIPTOR_ASSESSMENT = "0A106173736573736D656E742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22790A0F4173736573736F7252657175657374121E0A0A636F75727365436F6465180120012809520A636F75727365436F646512220A0C61737369676E6D656E744944180220012805520C61737369676E6D656E74494412220A0C6173736573736F72436F6465180320012809520C6173736573736F72436F646522420A0C4C6F67696E5265717565737412160A067573657249441801200128095206757365724944121A0A0870617373776F7264180220012809520870617373776F7264224E0A0D4C6F67696E526573706F6E736512180A077375636365737318012001280852077375636365737312230A0770726F66696C6518022001280E32092E50726F66696C6573520770726F66696C652297010A06436F7572736512120A04636F64651801200128095204636F646512120A046E616D6518022001280952046E616D65122D0A0B61737369676E6D656E747318032003280B320B2E41737369676E6D656E74520B61737369676E6D656E7473121A0A086173736573736F7218042001280952086173736573736F72121A0A0873747564656E7473180520032809520873747564656E747322720A0D436F7572736552657175657374121E0A0A636F75727365436F6465180120012809520A636F75727365436F646512120A046E616D6518022001280952046E616D65122D0A0B61737369676E6D656E747318032003280B320B2E41737369676E6D656E74520B61737369676E6D656E747322340A0A41737369676E6D656E74120E0A0269641801200128055202696412160A06776569676874180220012802520677656967687422B4010A0A5375626D697373696F6E121C0A0973747564656E744944180120012809520973747564656E74494412180A07636F6E74656E741802200128095207636F6E74656E7412120A046D61726B18032001280252046D61726B12160A066D61726B656418042001280852066D61726B6564121E0A0A636F75727365436F6465180520012809520A636F75727365436F646512220A0C61737369676E6D656E744944180620012805520C61737369676E6D656E74494422530A0D41737369676E52657175657374121E0A0A636F75727365436F6465180120012809520A636F75727365436F646512220A0C6173736573736F72436F6465180220012809520C6173736573736F72436F6465227E0A0B5573657252657175657374121A0A0875736572436F6465180120012809520875736572436F646512120A046E616D6518022001280952046E616D6512230A0770726F66696C6518032001280E32092E50726F66696C6573520770726F66696C65121A0A0870617373776F7264180420012809520870617373776F7264228F010A1141737369676E6D656E7452657175657374121E0A0A636F75727365436F6465180120012809520A636F75727365436F6465121C0A0973747564656E744944180220012809520973747564656E74494412180A07636F6E74656E741803200128095207636F6E74656E7412220A0C61737369676E6D656E744944180420012805520C61737369676E6D656E744944224B0A134173736573736F7241737369676E6D656E747312340A0B41737369676E6D656E747318012003280B32122E41737369676E6D656E7452657175657374520B41737369676E6D656E747322780A044D61726B12220A0C61737369676E6D656E744944180120012805520C61737369676E6D656E74494412120A046D61726B18022001280252046D61726B121C0A0973747564656E744944180320012809520973747564656E744944121A0A08636F7572736549441804200128095208636F757273654944223E0A08526567697374657212160A067573657249441801200128095206757365724944121A0A08636F7572736549441802200128095208636F75727365494422440A0E4372656174655573657244617461121A0A0875736572436F6465180120012809520875736572436F646512160A06737461747573180220012809520673746174757322390A1243726561746555736572526573706F6E736512230A046461746118012003280B320F2E43726561746555736572446174615204646174612A380A0850726F66696C6573120B0A074C4541524E4552100012110A0D41444D494E4953545241544F521001120C0A084153534553534F52100232CD030A0A4173736573736D656E7412410A0D6372656174655F636F75727365120E2E436F75727365526571756573741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001123B0A0D61737369676E5F636F75727365120E2E41737369676E526571756573741A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C756512320A0B6372656174655F75736572120C2E55736572526571756573741A132E43726561746555736572526573706F6E7365280112450A117375626D69745F61737369676E6D656E7412122E41737369676E6D656E74526571756573741A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565280112330A08726567697374657212092E52656769737465721A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565280112350A12726571756573745F61737369676E6D656E7412102E4173736573736F72526571756573741A0B2E5375626D697373696F6E300112300A0B7375626D69745F6D61726B12052E4D61726B1A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C756512260A056C6F67696E120D2E4C6F67696E526571756573741A0E2E4C6F67696E526573706F6E7365620670726F746F33";

public isolated function getDescriptorMapAssessment() returns map<string> {
    return {"assessment.proto": "0A106173736573736D656E742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22790A0F4173736573736F7252657175657374121E0A0A636F75727365436F6465180120012809520A636F75727365436F646512220A0C61737369676E6D656E744944180220012805520C61737369676E6D656E74494412220A0C6173736573736F72436F6465180320012809520C6173736573736F72436F646522420A0C4C6F67696E5265717565737412160A067573657249441801200128095206757365724944121A0A0870617373776F7264180220012809520870617373776F7264224E0A0D4C6F67696E526573706F6E736512180A077375636365737318012001280852077375636365737312230A0770726F66696C6518022001280E32092E50726F66696C6573520770726F66696C652297010A06436F7572736512120A04636F64651801200128095204636F646512120A046E616D6518022001280952046E616D65122D0A0B61737369676E6D656E747318032003280B320B2E41737369676E6D656E74520B61737369676E6D656E7473121A0A086173736573736F7218042001280952086173736573736F72121A0A0873747564656E7473180520032809520873747564656E747322720A0D436F7572736552657175657374121E0A0A636F75727365436F6465180120012809520A636F75727365436F646512120A046E616D6518022001280952046E616D65122D0A0B61737369676E6D656E747318032003280B320B2E41737369676E6D656E74520B61737369676E6D656E747322340A0A41737369676E6D656E74120E0A0269641801200128055202696412160A06776569676874180220012802520677656967687422B4010A0A5375626D697373696F6E121C0A0973747564656E744944180120012809520973747564656E74494412180A07636F6E74656E741802200128095207636F6E74656E7412120A046D61726B18032001280252046D61726B12160A066D61726B656418042001280852066D61726B6564121E0A0A636F75727365436F6465180520012809520A636F75727365436F646512220A0C61737369676E6D656E744944180620012805520C61737369676E6D656E74494422530A0D41737369676E52657175657374121E0A0A636F75727365436F6465180120012809520A636F75727365436F646512220A0C6173736573736F72436F6465180220012809520C6173736573736F72436F6465227E0A0B5573657252657175657374121A0A0875736572436F6465180120012809520875736572436F646512120A046E616D6518022001280952046E616D6512230A0770726F66696C6518032001280E32092E50726F66696C6573520770726F66696C65121A0A0870617373776F7264180420012809520870617373776F7264228F010A1141737369676E6D656E7452657175657374121E0A0A636F75727365436F6465180120012809520A636F75727365436F6465121C0A0973747564656E744944180220012809520973747564656E74494412180A07636F6E74656E741803200128095207636F6E74656E7412220A0C61737369676E6D656E744944180420012805520C61737369676E6D656E744944224B0A134173736573736F7241737369676E6D656E747312340A0B41737369676E6D656E747318012003280B32122E41737369676E6D656E7452657175657374520B41737369676E6D656E747322780A044D61726B12220A0C61737369676E6D656E744944180120012805520C61737369676E6D656E74494412120A046D61726B18022001280252046D61726B121C0A0973747564656E744944180320012809520973747564656E744944121A0A08636F7572736549441804200128095208636F757273654944223E0A08526567697374657212160A067573657249441801200128095206757365724944121A0A08636F7572736549441802200128095208636F75727365494422440A0E4372656174655573657244617461121A0A0875736572436F6465180120012809520875736572436F646512160A06737461747573180220012809520673746174757322390A1243726561746555736572526573706F6E736512230A046461746118012003280B320F2E43726561746555736572446174615204646174612A380A0850726F66696C6573120B0A074C4541524E4552100012110A0D41444D494E4953545241544F521001120C0A084153534553534F52100232CD030A0A4173736573736D656E7412410A0D6372656174655F636F75727365120E2E436F75727365526571756573741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001123B0A0D61737369676E5F636F75727365120E2E41737369676E526571756573741A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C756512320A0B6372656174655F75736572120C2E55736572526571756573741A132E43726561746555736572526573706F6E7365280112450A117375626D69745F61737369676E6D656E7412122E41737369676E6D656E74526571756573741A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565280112330A08726567697374657212092E52656769737465721A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565280112350A12726571756573745F61737369676E6D656E7412102E4173736573736F72526571756573741A0B2E5375626D697373696F6E300112300A0B7375626D69745F6D61726B12052E4D61726B1A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C756512260A056C6F67696E120D2E4C6F67696E526571756573741A0E2E4C6F67696E526573706F6E7365620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

