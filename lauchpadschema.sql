Drop Table If Exists Comment;
Drop Table If Exists TicketLog;
Drop Table If Exists Assignment;
Drop Table If Exists Task;
Drop Table If Exists Ticket;
Drop Table If Exists Sprint;
Drop Table If Exists ProjectMember;
Drop Table If Exists Project;
Drop Table If Exists Organization;
Drop Table If Exists PadUser;
Drop Table If Exists UserRole;

Go

Create Table UserRole
(
	RoleID int identity(1,1) primary key not null,
	Title varchar(50) not null
)

Create Table PadUser 
(
	UserID int identity(1,1) primary key not null,
	FirstName varchar(50) not null,
	LastName varchar(50) not null,
	Email varchar(100) not null,
	Password varchar(50) not null,
	Phone varchar(13),
	RoleID int not null foreign key (RoleID) references UserRole(RoleID)
)

Create Table Organization 
(
	OrganizationID int identity(1,1) primary key not null,
	OrgName varchar(50) not null,
	Email varchar(50) not null,
	Phone varchar(13)
)

Create Table Project 
(
	ProjectID int identity(1,1) primary key not null,
	ProjectName varchar(50) not null,
	ProjectDescription varchar(300) not null,
	DateStarted Date not null,
	DateClosed Date null,
	OrganizationID int not null foreign key (OrganizationID) references Organization(OrganizationID)
)

Create Table ProjectMember 
(
	ProjectMemberID int identity(1,1) primary key not null,
	UserID int not null foreign key (UserID) references PadUser(UserID),
	ProjectID int not null foreign key (ProjectID) references Project(ProjectID)
)

Create Table Sprint 
(
	SprintID int identity(1,1) primary key not null,
	Goal varchar(300) not null,
	SprintStatus varchar(50) not null Constraint ck_sprint_status_enum Check (SprintStatus in ('Planning', 'Active', 'InActive')) default 'Planning',
	StartDate Date not null,
	EndDate Date null,
	TotalPoints int not null,
	ProjectID int not null foreign key (ProjectID) references Project(ProjectID)
)

Create Table Ticket 
(
	TicketID int identity(1,1) primary key not null,
	TicketDescription varchar(300) not null,
	Points int not null,
	TicketPriority varchar(50) not null Constraint ck_ticket_priority_enum Check (TicketPriority in ('Low', 'Medium', 'High')) default 'Medium',
	CreatedDate Date not null,
	ClosedDate Date null,
	TicketStatus varchar(50) not null Constraint ck_ticket_status_enum Check (TicketStatus in ('Backlog', 'To-Do', 'In-Progress', 'In-Review', 'Done')) default 'Backlog',
	AssignedToUser int null foreign key (AssignedToUser) references PadUser(UserID),
	LastModifiedByUser int null foreign key (LastModifiedByUser) references PadUser(UserID),
	ProjectID int not null foreign key (ProjectID) references Project(ProjectID),
	SprintID int null foreign key (SprintID) references Sprint(SprintID)
)

Create Table Task (
	TaskID int identity(1,1) primary key not null,
	Title varchar(50) not null,
	TaskDescription varchar(300) not null,
	TaskPriority varchar(50) not null Constraint ck_task_priority_enum Check (TaskPriority in ('Low', 'Medium', 'High')) default 'Medium',
	OrderValue int not null,
	TaskStatus varchar(50) not null Constraint ck_task_status_enum Check (TaskStatus in ('Backlog', 'To-Do', 'In-Progress', 'In-Review', 'Done')) default 'Backlog',
	TicketID int null foreign key (TicketID) references Ticket(TicketID)
)

Create Table Assignment
(
	AssignmentID int identity(1,1) primary key not null,
	DateAssigned Date not null,
	DateStarted Date null,
	DateFinished Date null,
	UserID int not null foreign key (UserID) references PadUser(UserID),
	TicketID int not null foreign key (TicketID) references Ticket(TicketID)
)

Create Table TicketLog
(
	TicketLogID int identity(1,1) primary key not null,
	OldStatus varchar(50) not null Constraint ck_ticketlog_oldstatus_enum Check (OldStatus in ('Backlog', 'To-Do', 'In-Progress', 'In-Review', 'Done')),
	NewStatus varchar(50) not null Constraint ck_ticketlog_newstatus_enum Check (NewStatus in ('Backlog', 'To-Do', 'In-Progress', 'In-Review', 'Done')),
	DateCreated Date not null,
	Note varchar(300) null,
	UserID int not null foreign key (UserID) references PadUser(UserID),
	TicketID int not null foreign key (TicketID) references Ticket(TicketID)
)

Create Table Comment
(
	CommentID int identity(1,1) primary key not null,
	CommentDate Date not null,
	Content varchar(1000) not null,
	ParentCommentID int null foreign key (ParentCommentID) references Comment(CommentID),
	UserID int not null foreign key (UserID) references PadUser(UserID),
	TicketID int not null foreign key (TicketID) references Ticket(TicketID)
)

Go

Create Index IX_Ticket_ProjectID On Ticket(ProjectID);
Create Index IX_Ticket_SprintID On Ticket(SprintID);
Create Index IX_Ticket_TicketStatus On Ticket(TicketStatus);
Create Index IX_Ticket_AssignedToUser On Ticket(AssignedToUser);

Create Index IX_Task_TicketID On Task(TicketID);
Create Index IX_Task_TaskStatus On Task(TaskStatus);

Create Index IX_Assignment_UserID On Assignment(UserID);
Create Index IX_Assignment_TicketID On Assignment(TicketID);

Create Index IX_Comment_TicketID On Comment(TicketID);
Create Index IX_Comment_ParentCommentID On Comment(ParentCommentID);

Create Index IX_Sprint_ProjectID On Sprint(ProjectID);

Create Index IX_ProjectMember_ProjectID On ProjectMember(ProjectID);
Create Index IX_ProjectMember_UserID On ProjectMember(UserID);

Go

-- =============================================
-- DUMMY DATA
-- =============================================

-- Roles
Insert Into UserRole (Title) Values ('Scrum Leader');
Insert Into UserRole (Title) Values ('Developer');
Insert Into UserRole (Title) Values ('QA');

-- Organizations
Insert Into Organization (OrgName, Email, Phone) Values ('TechCorp', 'contact@techcorp.com', '555-100-1000');
Insert Into Organization (OrgName, Email, Phone) Values ('DataWorks', 'info@dataworks.com', '555-200-2000');
Insert Into Organization (OrgName, Email, Phone) Values ('CloudNine', 'hello@cloudnine.com', '555-300-3000');

-- Users: 3 Scrum Leaders + 9 Developers + 9 QAs = 21 total
-- Scrum Leaders (RoleID = 1)
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Alice', 'Johnson', 'alice.johnson@techcorp.com', 'password123', '555-101-0001', 1);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Bob', 'Smith', 'bob.smith@dataworks.com', 'password123', '555-201-0001', 1);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Carol', 'Williams', 'carol.williams@cloudnine.com', 'password123', '555-301-0001', 1);

-- TechCorp Developers (RoleID = 2) - UserID 4, 5, 6
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Dan', 'Brown', 'dan.brown@techcorp.com', 'password123', '555-101-0002', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Eve', 'Davis', 'eve.davis@techcorp.com', 'password123', '555-101-0003', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Frank', 'Miller', 'frank.miller@techcorp.com', 'password123', '555-101-0004', 2);

-- TechCorp QAs (RoleID = 3) - UserID 7, 8, 9
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Grace', 'Wilson', 'grace.wilson@techcorp.com', 'password123', '555-101-0005', 3);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Hank', 'Moore', 'hank.moore@techcorp.com', 'password123', '555-101-0006', 3);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Ivy', 'Taylor', 'ivy.taylor@techcorp.com', 'password123', '555-101-0007', 3);

-- DataWorks Developers (RoleID = 2) - UserID 10, 11, 12
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Jack', 'Anderson', 'jack.anderson@dataworks.com', 'password123', '555-201-0002', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Kate', 'Thomas', 'kate.thomas@dataworks.com', 'password123', '555-201-0003', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Leo', 'Jackson', 'leo.jackson@dataworks.com', 'password123', '555-201-0004', 2);

-- DataWorks QAs (RoleID = 3) - UserID 13, 14, 15
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Mia', 'White', 'mia.white@dataworks.com', 'password123', '555-201-0005', 3);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Nick', 'Harris', 'nick.harris@dataworks.com', 'password123', '555-201-0006', 3);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Olivia', 'Martin', 'olivia.martin@dataworks.com', 'password123', '555-201-0007', 3);

-- CloudNine Developers (RoleID = 2) - UserID 16, 17, 18
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Paul', 'Garcia', 'paul.garcia@cloudnine.com', 'password123', '555-301-0002', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Quinn', 'Martinez', 'quinn.martinez@cloudnine.com', 'password123', '555-301-0003', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Rachel', 'Robinson', 'rachel.robinson@cloudnine.com', 'password123', '555-301-0004', 2);

-- CloudNine QAs (RoleID = 3) - UserID 19, 20, 21
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Sam', 'Clark', 'sam.clark@cloudnine.com', 'password123', '555-301-0005', 3);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Tina', 'Lewis', 'tina.lewis@cloudnine.com', 'password123', '555-301-0006', 3);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Uma', 'Lee', 'uma.lee@cloudnine.com', 'password123', '555-301-0007', 3);

-- Projects (3 per organization = 9 total)
-- TechCorp Projects (OrgID = 1)
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('Website Redesign', 'Complete overhaul of the company website with modern UI/UX', '2025-01-15', null, 1);
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('Mobile App', 'Native mobile application for iOS and Android', '2025-02-01', null, 1);
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('API Gateway', 'Centralized API gateway for microservices', '2025-01-20', null, 1);

-- DataWorks Projects (OrgID = 2)
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('Data Pipeline', 'Real-time data processing pipeline', '2025-01-10', null, 2);
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('Analytics Dashboard', 'Business intelligence dashboard for stakeholders', '2025-02-05', null, 2);
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('ML Platform', 'Machine learning model training and deployment platform', '2025-01-25', null, 2);

-- CloudNine Projects (OrgID = 3)
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('Cloud Migration', 'Migrate legacy systems to cloud infrastructure', '2025-01-05', null, 3);
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('DevOps Toolkit', 'CI/CD pipeline and infrastructure automation tools', '2025-02-10', null, 3);
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('Security Suite', 'Comprehensive security monitoring and alerting system', '2025-01-30', null, 3);

-- ProjectMembers (Scrum Leader + 1 Dev + 1 QA per project)
-- TechCorp Projects (ProjectID 1, 2, 3) - Leader: Alice (1), Devs: 4,5,6, QAs: 7,8,9
Insert Into ProjectMember (UserID, ProjectID) Values (1, 1);  -- Alice -> Website Redesign
Insert Into ProjectMember (UserID, ProjectID) Values (4, 1);  -- Dan -> Website Redesign
Insert Into ProjectMember (UserID, ProjectID) Values (7, 1);  -- Grace -> Website Redesign

Insert Into ProjectMember (UserID, ProjectID) Values (1, 2);  -- Alice -> Mobile App
Insert Into ProjectMember (UserID, ProjectID) Values (5, 2);  -- Eve -> Mobile App
Insert Into ProjectMember (UserID, ProjectID) Values (8, 2);  -- Hank -> Mobile App

Insert Into ProjectMember (UserID, ProjectID) Values (1, 3);  -- Alice -> API Gateway
Insert Into ProjectMember (UserID, ProjectID) Values (6, 3);  -- Frank -> API Gateway
Insert Into ProjectMember (UserID, ProjectID) Values (9, 3);  -- Ivy -> API Gateway

-- DataWorks Projects (ProjectID 4, 5, 6) - Leader: Bob (2), Devs: 10,11,12, QAs: 13,14,15
Insert Into ProjectMember (UserID, ProjectID) Values (2, 4);  -- Bob -> Data Pipeline
Insert Into ProjectMember (UserID, ProjectID) Values (10, 4); -- Jack -> Data Pipeline
Insert Into ProjectMember (UserID, ProjectID) Values (13, 4); -- Mia -> Data Pipeline

Insert Into ProjectMember (UserID, ProjectID) Values (2, 5);  -- Bob -> Analytics Dashboard
Insert Into ProjectMember (UserID, ProjectID) Values (11, 5); -- Kate -> Analytics Dashboard
Insert Into ProjectMember (UserID, ProjectID) Values (14, 5); -- Nick -> Analytics Dashboard

Insert Into ProjectMember (UserID, ProjectID) Values (2, 6);  -- Bob -> ML Platform
Insert Into ProjectMember (UserID, ProjectID) Values (12, 6); -- Leo -> ML Platform
Insert Into ProjectMember (UserID, ProjectID) Values (15, 6); -- Olivia -> ML Platform

-- CloudNine Projects (ProjectID 7, 8, 9) - Leader: Carol (3), Devs: 16,17,18, QAs: 19,20,21
Insert Into ProjectMember (UserID, ProjectID) Values (3, 7);  -- Carol -> Cloud Migration
Insert Into ProjectMember (UserID, ProjectID) Values (16, 7); -- Paul -> Cloud Migration
Insert Into ProjectMember (UserID, ProjectID) Values (19, 7); -- Sam -> Cloud Migration

Insert Into ProjectMember (UserID, ProjectID) Values (3, 8);  -- Carol -> DevOps Toolkit
Insert Into ProjectMember (UserID, ProjectID) Values (17, 8); -- Quinn -> DevOps Toolkit
Insert Into ProjectMember (UserID, ProjectID) Values (20, 8); -- Tina -> DevOps Toolkit

Insert Into ProjectMember (UserID, ProjectID) Values (3, 9);  -- Carol -> Security Suite
Insert Into ProjectMember (UserID, ProjectID) Values (18, 9); -- Rachel -> Security Suite
Insert Into ProjectMember (UserID, ProjectID) Values (21, 9); -- Uma -> Security Suite

-- Sprints (1 active sprint per project = 9 total)
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Complete homepage redesign and navigation overhaul', 'Active', '2025-02-01', '2025-02-14', 21, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Build user authentication and onboarding flow', 'Active', '2025-02-03', '2025-02-17', 18, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Implement rate limiting and request validation', 'Active', '2025-02-01', '2025-02-14', 15, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Set up data ingestion from external sources', 'Active', '2025-02-01', '2025-02-14', 24, 4);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Create main dashboard with key metrics', 'Active', '2025-02-05', '2025-02-19', 20, 5);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Build model training pipeline infrastructure', 'Active', '2025-02-03', '2025-02-17', 26, 6);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Migrate database servers to cloud', 'Active', '2025-02-01', '2025-02-14', 22, 7);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Set up automated build and test pipelines', 'Active', '2025-02-10', '2025-02-24', 19, 8);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, TotalPoints, ProjectID) Values ('Implement intrusion detection system', 'Active', '2025-02-03', '2025-02-17', 23, 9);

-- Tickets (3 per sprint = 27 total, various statuses)
-- Sprint 1: Website Redesign (ProjectID=1, SprintID=1, Dev=Dan(4), QA=Grace(7))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Design and implement new navigation header with responsive menu', 8, 'High', '2025-02-01', null, 'In-Progress', 4, 4, 1, 1);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Create hero section with animated banner and CTA buttons', 5, 'Medium', '2025-02-01', null, 'To-Do', 4, 1, 1, 1);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Build footer component with sitemap and social links', 8, 'Low', '2025-02-01', null, 'Backlog', null, 1, 1, 1);

-- Sprint 2: Mobile App (ProjectID=2, SprintID=2, Dev=Eve(5), QA=Hank(8))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Implement user login with email and password authentication', 8, 'High', '2025-02-03', null, 'In-Review', 5, 5, 2, 2);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Create user registration flow with email verification', 5, 'High', '2025-02-03', null, 'In-Progress', 5, 5, 2, 2);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Build welcome tutorial screens for new users', 5, 'Medium', '2025-02-03', null, 'To-Do', null, 1, 2, 2);

-- Sprint 3: API Gateway (ProjectID=3, SprintID=3, Dev=Frank(6), QA=Ivy(9))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Implement token bucket rate limiting algorithm', 5, 'High', '2025-02-01', '2025-02-10', 'Done', 6, 9, 3, 3);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Add request payload validation middleware', 5, 'High', '2025-02-01', null, 'In-Review', 6, 6, 3, 3);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Create API documentation with Swagger integration', 5, 'Medium', '2025-02-01', null, 'In-Progress', 6, 6, 3, 3);

-- Sprint 4: Data Pipeline (ProjectID=4, SprintID=4, Dev=Jack(10), QA=Mia(13))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Set up Kafka consumers for real-time event streaming', 8, 'High', '2025-02-01', null, 'In-Progress', 10, 10, 4, 4);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Implement data transformation and cleaning logic', 8, 'High', '2025-02-01', null, 'To-Do', 10, 2, 4, 4);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Create dead letter queue for failed messages', 8, 'Medium', '2025-02-01', null, 'Backlog', null, 2, 4, 4);

-- Sprint 5: Analytics Dashboard (ProjectID=5, SprintID=5, Dev=Kate(11), QA=Nick(14))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Build revenue metrics chart with daily/weekly/monthly views', 8, 'High', '2025-02-05', null, 'In-Progress', 11, 11, 5, 5);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Create user engagement funnel visualization', 5, 'Medium', '2025-02-05', null, 'To-Do', 11, 2, 5, 5);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Implement dashboard filters and date range selector', 7, 'Medium', '2025-02-05', null, 'Backlog', null, 2, 5, 5);

-- Sprint 6: ML Platform (ProjectID=6, SprintID=6, Dev=Leo(12), QA=Olivia(15))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Set up distributed training infrastructure with GPU support', 10, 'High', '2025-02-03', null, 'In-Progress', 12, 12, 6, 6);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Implement model versioning and artifact storage', 8, 'High', '2025-02-03', null, 'To-Do', 12, 2, 6, 6);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Create training job scheduler with priority queues', 8, 'Medium', '2025-02-03', null, 'Backlog', null, 2, 6, 6);

-- Sprint 7: Cloud Migration (ProjectID=7, SprintID=7, Dev=Paul(16), QA=Sam(19))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Migrate primary PostgreSQL database to cloud-managed instance', 10, 'High', '2025-02-01', null, 'In-Review', 16, 16, 7, 7);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Set up database replication and failover configuration', 7, 'High', '2025-02-01', null, 'In-Progress', 16, 16, 7, 7);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Configure automated backup and point-in-time recovery', 5, 'Medium', '2025-02-01', null, 'To-Do', null, 3, 7, 7);

-- Sprint 8: DevOps Toolkit (ProjectID=8, SprintID=8, Dev=Quinn(17), QA=Tina(20))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Create GitHub Actions workflow for automated builds', 5, 'High', '2025-02-10', '2025-02-18', 'Done', 17, 20, 8, 8);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Set up automated test execution on pull requests', 7, 'High', '2025-02-10', null, 'In-Progress', 17, 17, 8, 8);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Implement deployment automation to staging environment', 7, 'Medium', '2025-02-10', null, 'To-Do', 17, 3, 8, 8);

-- Sprint 9: Security Suite (ProjectID=9, SprintID=9, Dev=Rachel(18), QA=Uma(21))
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Implement network traffic anomaly detection algorithm', 10, 'High', '2025-02-03', null, 'In-Progress', 18, 18, 9, 9);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Create real-time alerting system with severity levels', 8, 'High', '2025-02-03', null, 'To-Do', 18, 3, 9, 9);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID)
Values ('Build security incident dashboard with threat visualization', 5, 'Medium', '2025-02-03', null, 'Backlog', null, 3, 9, 9);

-- Tasks (2-3 per ticket for tickets that are In-Progress or In-Review)
-- Ticket 1: Navigation header (In-Progress)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Create header component', 'Build base React component with responsive breakpoints', 'High', 1, 'Done', 1);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Implement mobile menu', 'Add hamburger menu with slide-out navigation for mobile', 'High', 2, 'In-Progress', 1);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add dropdown submenus', 'Create nested dropdown menus for main navigation items', 'Medium', 3, 'To-Do', 1);

-- Ticket 4: User login (In-Review)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Create login form UI', 'Build login form with email and password fields', 'High', 1, 'Done', 4);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Implement auth API call', 'Connect login form to authentication backend API', 'High', 2, 'Done', 4);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add form validation', 'Implement client-side validation with error messages', 'Medium', 3, 'Done', 4);

-- Ticket 5: User registration (In-Progress)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Create registration form', 'Build multi-step registration form component', 'High', 1, 'Done', 5);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Implement email verification', 'Send verification email and handle confirmation link', 'High', 2, 'In-Progress', 5);

-- Ticket 8: Rate limiting (Done)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Design rate limit algorithm', 'Implement token bucket with configurable limits', 'High', 1, 'Done', 8);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add Redis storage', 'Store rate limit counters in Redis for distributed support', 'High', 2, 'Done', 8);

-- Ticket 9: Request validation (In-Review)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Create validation middleware', 'Build Express middleware for request validation', 'High', 1, 'Done', 9);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add JSON schema validation', 'Implement JSON schema validation for request bodies', 'High', 2, 'Done', 9);

-- Ticket 10: Kafka consumers (In-Progress)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Set up Kafka client', 'Configure Kafka consumer with proper group settings', 'High', 1, 'Done', 10);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Implement message handler', 'Create message processing logic with error handling', 'High', 2, 'In-Progress', 10);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add monitoring metrics', 'Implement consumer lag and throughput metrics', 'Medium', 3, 'To-Do', 10);

-- Ticket 13: Revenue metrics chart (In-Progress)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Create chart component', 'Build reusable chart component with Chart.js', 'High', 1, 'Done', 13);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add time period toggle', 'Implement daily/weekly/monthly view switching', 'Medium', 2, 'In-Progress', 13);

-- Ticket 16: Distributed training (In-Progress)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Set up GPU cluster', 'Configure Kubernetes cluster with GPU node pools', 'High', 1, 'Done', 16);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Implement job distribution', 'Create logic to distribute training across nodes', 'High', 2, 'In-Progress', 16);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add checkpointing', 'Implement model checkpointing for fault tolerance', 'Medium', 3, 'To-Do', 16);

-- Ticket 19: Database migration (In-Review)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Create migration script', 'Write script to export and import database schema', 'High', 1, 'Done', 19);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Migrate data', 'Transfer all production data to cloud instance', 'High', 2, 'Done', 19);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Verify data integrity', 'Run checksums and row counts to verify migration', 'High', 3, 'Done', 19);

-- Ticket 20: Database replication (In-Progress)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Configure read replicas', 'Set up read replicas in multiple availability zones', 'High', 1, 'Done', 20);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Set up failover', 'Configure automatic failover with health checks', 'High', 2, 'In-Progress', 20);

-- Ticket 22: GitHub Actions (Done)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Create workflow file', 'Write GitHub Actions YAML workflow configuration', 'High', 1, 'Done', 22);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add build steps', 'Configure build, lint, and compile steps', 'High', 2, 'Done', 22);

-- Ticket 23: Automated tests (In-Progress)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Set up test runner', 'Configure Jest test runner in CI pipeline', 'High', 1, 'Done', 23);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add PR trigger', 'Configure workflow to run on pull request events', 'Medium', 2, 'In-Progress', 23);

-- Ticket 25: Anomaly detection (In-Progress)
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Research algorithms', 'Evaluate anomaly detection algorithms for network data', 'High', 1, 'Done', 25);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Implement baseline model', 'Create baseline traffic pattern model', 'High', 2, 'In-Progress', 25);
Insert Into Task (Title, TaskDescription, TaskPriority, OrderValue, TaskStatus, TicketID) Values ('Add real-time scoring', 'Implement real-time anomaly scoring engine', 'High', 3, 'To-Do', 25);

-- Assignments (for tickets with assigned users)
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', '2025-02-02', null, 4, 1);   -- Dan -> Navigation header
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', null, null, 4, 2);          -- Dan -> Hero section
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-03', '2025-02-04', null, 5, 4);  -- Eve -> User login
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-03', '2025-02-08', null, 5, 5);  -- Eve -> Registration
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', '2025-02-02', '2025-02-10', 6, 8);  -- Frank -> Rate limiting (Done)
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', '2025-02-05', null, 6, 9);  -- Frank -> Request validation
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', '2025-02-06', null, 6, 10); -- Frank -> Swagger docs
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', '2025-02-02', null, 10, 10); -- Jack -> Kafka consumers
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', null, null, 10, 11);        -- Jack -> Data transformation
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-05', '2025-02-06', null, 11, 13); -- Kate -> Revenue metrics
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-05', null, null, 11, 14);        -- Kate -> Engagement funnel
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-03', '2025-02-04', null, 12, 16); -- Leo -> Distributed training
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-03', null, null, 12, 17);        -- Leo -> Model versioning
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', '2025-02-02', null, 16, 19); -- Paul -> DB migration
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-01', '2025-02-10', null, 16, 20); -- Paul -> DB replication
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-10', '2025-02-11', '2025-02-18', 17, 22); -- Quinn -> GitHub Actions (Done)
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-10', '2025-02-15', null, 17, 23); -- Quinn -> Automated tests
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-10', null, null, 17, 24);        -- Quinn -> Deployment automation
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-03', '2025-02-04', null, 18, 25); -- Rachel -> Anomaly detection
Insert Into Assignment (DateAssigned, DateStarted, DateFinished, UserID, TicketID) Values ('2025-02-03', null, null, 18, 26);        -- Rachel -> Alerting system

-- TicketLog (status change history for some tickets)
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('Backlog', 'To-Do', '2025-02-01', 'Sprint planning - moved to sprint', 1, 1);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('To-Do', 'In-Progress', '2025-02-02', 'Started working on navigation', 4, 1);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('Backlog', 'To-Do', '2025-02-03', 'Added to sprint backlog', 1, 4);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('To-Do', 'In-Progress', '2025-02-04', 'Beginning login implementation', 5, 4);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('In-Progress', 'In-Review', '2025-02-12', 'Ready for QA review', 5, 4);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('Backlog', 'To-Do', '2025-02-01', 'Sprint started', 1, 8);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('To-Do', 'In-Progress', '2025-02-02', 'Started rate limiting work', 6, 8);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('In-Progress', 'In-Review', '2025-02-08', 'Implementation complete', 6, 8);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('In-Review', 'Done', '2025-02-10', 'QA approved - all tests passing', 9, 8);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('Backlog', 'To-Do', '2025-02-10', 'Added to sprint', 3, 22);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('To-Do', 'In-Progress', '2025-02-11', 'Starting workflow setup', 17, 22);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('In-Progress', 'In-Review', '2025-02-16', 'Ready for review', 17, 22);
Insert Into TicketLog (OldStatus, NewStatus, DateCreated, Note, UserID, TicketID) Values ('In-Review', 'Done', '2025-02-18', 'Approved and merged', 20, 22);

-- Comments (discussions on some tickets)
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-02', 'Started on the header component. Planning to use CSS Grid for the layout.', null, 4, 1);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-03', 'Sounds good! Make sure it works well on tablet sizes too.', 1, 1, 1);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-04', 'Will do. I am adding breakpoints at 768px and 1024px.', 2, 4, 1);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-12', 'Login flow is complete. Used JWT tokens for session management.', null, 5, 4);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-12', 'Great work! I will start QA testing tomorrow.', 4, 8, 4);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-08', 'Rate limiting is working well. Tested with 1000 requests per minute limit.', null, 6, 8);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-09', 'Can we make the limit configurable per endpoint?', 6, 1, 8);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-09', 'Yes, I added a config file for per-route limits. Updated the PR.', 7, 6, 8);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-10', 'Perfect. Approving this ticket.', 8, 9, 8);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-11', 'Setting up the GitHub Actions workflow now. Using the latest ubuntu runner.', null, 17, 22);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-16', 'Workflow is running smoothly. Build time is around 3 minutes.', 10, 17, 22);
Insert Into Comment (CommentDate, Content, ParentCommentID, UserID, TicketID) Values ('2025-02-18', 'Tested on multiple branches. Looks good to merge!', 11, 20, 22);