import ballerina/http;

import ballerina/io;

public type Student record {|
    readonly string student_No;
    string Email_Address;
    string Student_Name;
    string Course;
    string[] courses = [];
|};

public type Submission record {|
    readonly string student_No;
    float mark;
    string content;
|};

public type Assignment record {|
    readonly string id;
    float weight;
    table<Submission> submissions;
|};

public type Course record {|
    readonly string code;
    table<Assignment> assignments;
|};

table<Student> key(student_No) students = table [
        {student_No: "200602942", Student_Name: "Mervin Rudolf", Email_Address: "200602942@students.nust.na", Course: "Distributed Systems", courses: ["DSA620S"]}
            ];

table<Course> key(code) courses = table [
        {
            code: "DSA620S",
            assignments: table [
                            {
                                id: "522",
                                weight: 0.5,
                                submissions: table [
                                    {
                                        student_No: "200602942",
                                        content: "submission",
                                        mark: 0.0
                                    }
                                ]
                            }
                        ]
        }
];

public type StudentRequest record {|
    string student_No;
    string Student_Name = "";
    string Email_Address = "";
    string Course = "";
|};

public type CourseRequest record {|
    string student_No;
    string course;
|};

service / on new http:Listener(8080) {
    // path to create a new student account
    resource function post create(@http:Payload Student payload) returns json {
        // string? student_No = payload.student_No;
        students.add({student_No: payload.student_No, Student_Name: payload.Student_Name, Email_Address: payload.Email_Address, Course: payload.Course, courses: []});

        io:println(students.toBalString());
        return {success: true, message: "Student successfully created."};
    }

    resource function put update(@http:Payload StudentRequest payload) returns json {

        io:println(payload.toBalString());
        Student student = students.get(payload.student_No);

        if (payload.Course !== "") {
            student.Course = payload.Course;

        }

        if (payload.Email_Address !== "") {
            student.Email_Address = payload.Email_Address;

        }

        if (payload.Student_Name !== "") {
            student.Student_Name = payload.Student_Name;
        }

        return {success: true, message: " Student details successfully updated"};

    }

    resource function put course(@http:Payload CourseRequest payload) returns json {

        Student student = students.get(payload.student_No);
        student.courses.push(payload.course);

        return {success: true, message: "course has been successfully added"};
    }

    resource function get lookup(string student_No) returns Student {
        return students.get(student_No);
    }

    resource function get all() returns json {
        return students.toJson();
    }

    resource function delete delete(string student_No) returns json {
        Student result = students.remove(student_No);

        io:println(students.toBalString());
        return {success: true, message: "Student Succefully deleted"};

    }
}
