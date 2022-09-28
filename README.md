# DSA_Assignment1_2022

Assignment
• Course Title: Distributed Systems and Applications
• Course Code: DSA621S
• Assessment: First Assignment
• Released on: 06/09/2022
• Due Date: 25/09/2022
Problem 1
Marks: 50/100
Problem
In this problem, we wish to design and build components of an assessment
management system using gRPC. The system has three user profiles: learner,
administrator and assessor. Note that each user should have a unique identifier
in the system. A learner registers for courses, submits assignments for each
assessment of each course he/she registered for, and finally checks his/her result.
An administrator adds new courses and sets the number of assessments for each
course and the assessment weights. He/she also assigns assessors to each course.
Finally, an assessor allocated for a course assesses the assignments submitted.
In short, we have the following operations:
• create_courses, where an administrator creates several courses, defines
the number of assignments for each course and sets the weight for each
assignment. This operation returns the code for each created course. It is
bidirectional streaming;
• assign_courses, where an administrator assigns each created course to an
assessor;
• create_users, where several users, each with a specific profile, are created.
The users are streamed to the server, and the response is returned once
the operation completes;
• submit_assignments, where a learner submits one or several assignments
for one or multiple courses he/she registered for. The assignments are
streamed to the server, and the response is received once the operation
completes;
• request_assignments, where an assessor requests submitted assignments
for a course he/she has been allocated. Note that an assignment can be
marked only once. The function should stream back all assignments that
have not been marked yet;
• submit_marks, where an assessor submits the marks for assignments;
• register, where a learner registers for one or several courses. All the courses
are streamed to the server, and the result is returned once the operation
completes;
1
Your task is to define a protocol buffer contract with the remote functions and
implement both the client and the server in the Ballerina Language.
Assessment Criteria
We will follow the criteria below to assess this problem:
• Definition of the remote interface in Protocol Buffer. (25%)
• Implementation of the gRPC client in the Ballerina language. (25%)
• Implementation of the gRPC server and server-side logic in response to
the remote invocations in the Ballerina Language. (50%)

Problem 3
Marks: 30/100
2
Problem
This problem focuses on a Restful API to manage a student record. A student
is defined by a student number, a name, an email address and the courses the
student took. For each course, there is the course code, the weights of the
assessments in the course and the marks awarded for each assessment. The API
should fulfil the following functions:
• Create a new student;
• Update student details;
• Update student’s course details;
• lookup a single student;
• fetch all students;
• delete a student.
Note that the student number should serve as a unique identifier for a student.
Your task is to define the API following the OpenAPI standard and implement
the client and service in the Ballerina language.
Evaluation criteria
We will follow the criteria below to assess this problem:
• A correct description of the API in OpenAPI. (40%)
• Implementation of the restful client and service in the Ballerina language.
(50%)
• Quality of design and implementation. (10%)
