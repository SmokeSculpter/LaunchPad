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
	EarnedPoints int not null default 0,
	TotalPoints int not null,
	ProjectID int not null foreign key (ProjectID) references Project(ProjectID)
)

Create Table Ticket 
(
	TicketID int identity(1,1) primary key not null,
	TicketDescription varchar(300) not null,
	TicketType varchar(50) not null Constraint ck_ticket_type_enum Check (TicketType in ('Feature', 'Bug', 'Maintenance', 'Test')) default 'Feature',
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

-- Roles (RoleID: 1=Scrum Leader, 2=Developer, 3=QA)
Insert Into UserRole (Title) Values ('Scrum Leader');
Insert Into UserRole (Title) Values ('Developer');
Insert Into UserRole (Title) Values ('QA');

-- Organization (OrganizationID = 1)
Insert Into Organization (OrgName, Email, Phone) Values ('TechCorp', 'contact@techcorp.com', '555-100-1000');

-- Users: 9 total (3 per project: 1 Scrum Leader, 1 Developer, 1 QA)
-- Project 1 Team (UserID 1, 2, 3)
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Alice', 'Johnson', 'alice.johnson@techcorp.com', 'password123', '555-101-0001', 1);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Dan', 'Brown', 'dan.brown@techcorp.com', 'password123', '555-101-0002', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Grace', 'Wilson', 'grace.wilson@techcorp.com', 'password123', '555-101-0003', 3);

-- Project 2 Team (UserID 4, 5, 6)
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Bob', 'Smith', 'bob.smith@techcorp.com', 'password123', '555-102-0001', 1);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Eve', 'Davis', 'eve.davis@techcorp.com', 'password123', '555-102-0002', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Hank', 'Moore', 'hank.moore@techcorp.com', 'password123', '555-102-0003', 3);

-- Project 3 Team (UserID 7, 8, 9)
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Carol', 'Williams', 'carol.williams@techcorp.com', 'password123', '555-103-0001', 1);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Frank', 'Miller', 'frank.miller@techcorp.com', 'password123', '555-103-0002', 2);
Insert Into PadUser (FirstName, LastName, Email, Password, Phone, RoleID) Values ('Ivy', 'Taylor', 'ivy.taylor@techcorp.com', 'password123', '555-103-0003', 3);

-- Projects (3 projects, all under TechCorp OrgID=1)
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('Website Redesign', 'Complete overhaul of the company website with modern UI/UX', '2024-06-01', null, 1);
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('Mobile App', 'Native mobile application for iOS and Android', '2024-06-01', null, 1);
Insert Into Project (ProjectName, ProjectDescription, DateStarted, DateClosed, OrganizationID) Values ('API Gateway', 'Centralized API gateway for microservices', '2024-06-01', null, 1);

-- ProjectMembers (3 per project = 9 total)
-- Project 1: Website Redesign - Alice(1)=ScrumLeader, Dan(2)=Dev, Grace(3)=QA
Insert Into ProjectMember (UserID, ProjectID) Values (1, 1);
Insert Into ProjectMember (UserID, ProjectID) Values (2, 1);
Insert Into ProjectMember (UserID, ProjectID) Values (3, 1);

-- Project 2: Mobile App - Bob(4)=ScrumLeader, Eve(5)=Dev, Hank(6)=QA
Insert Into ProjectMember (UserID, ProjectID) Values (4, 2);
Insert Into ProjectMember (UserID, ProjectID) Values (5, 2);
Insert Into ProjectMember (UserID, ProjectID) Values (6, 2);

-- Project 3: API Gateway - Carol(7)=ScrumLeader, Frank(8)=Dev, Ivy(9)=QA
Insert Into ProjectMember (UserID, ProjectID) Values (7, 3);
Insert Into ProjectMember (UserID, ProjectID) Values (8, 3);
Insert Into ProjectMember (UserID, ProjectID) Values (9, 3);

-- =============================================
-- SPRINTS: 10 per project = 30 total
-- Each sprint is 2 weeks. Sprints 1-9 are InActive (completed). Sprint 10 is Active with EndDate null.
-- Project 1 starts 2024-06-03, Project 2 starts 2024-06-03, Project 3 starts 2024-06-03
-- =============================================

-- Project 1 Sprints (ProjectID=1) - SprintID 1-10
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Set up project scaffolding and base layout',           'InActive', '2024-06-03', '2024-06-14', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Build navigation and header components',               'InActive', '2024-06-17', '2024-06-28', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement homepage hero and content sections',          'InActive', '2024-07-01', '2024-07-12', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Create footer and responsive breakpoints',              'InActive', '2024-07-15', '2024-07-26', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Build contact form and about page',                     'InActive', '2024-07-29', '2024-08-09', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement blog listing and detail pages',               'InActive', '2024-08-12', '2024-08-23', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Add search functionality and filters',                  'InActive', '2024-08-26', '2024-09-06', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement user authentication pages',                   'InActive', '2024-09-09', '2024-09-20', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Performance optimization and accessibility audit',      'InActive', '2024-09-23', '2024-10-04', 25, 25, 1);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Final polish and launch preparation',                   'Active',   '2024-10-07', null,         0,  25, 1);

-- Project 2 Sprints (ProjectID=2) - SprintID 11-20
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Set up React Native project and navigation',            'InActive', '2024-06-03', '2024-06-14', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Build user registration and login screens',             'InActive', '2024-06-17', '2024-06-28', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement home feed and data fetching',                 'InActive', '2024-07-01', '2024-07-12', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Build user profile and settings screens',               'InActive', '2024-07-15', '2024-07-26', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Add push notifications and deep linking',               'InActive', '2024-07-29', '2024-08-09', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement offline mode and local storage',              'InActive', '2024-08-12', '2024-08-23', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Build messaging and chat feature',                      'InActive', '2024-08-26', '2024-09-06', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Add media upload and image handling',                   'InActive', '2024-09-09', '2024-09-20', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement analytics and crash reporting',               'InActive', '2024-09-23', '2024-10-04', 25, 25, 2);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('App store submission and final testing',                'Active',   '2024-10-07', null,         0,  25, 2);

-- Project 3 Sprints (ProjectID=3) - SprintID 21-30
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Design API architecture and set up Express server',     'InActive', '2024-06-03', '2024-06-14', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement authentication and JWT middleware',           'InActive', '2024-06-17', '2024-06-28', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Build CRUD endpoints for core resources',               'InActive', '2024-07-01', '2024-07-12', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Add rate limiting and request validation',              'InActive', '2024-07-15', '2024-07-26', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement caching layer with Redis',                   'InActive', '2024-07-29', '2024-08-09', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Build webhook system and event routing',               'InActive', '2024-08-12', '2024-08-23', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Add API versioning and deprecation support',           'InActive', '2024-08-26', '2024-09-06', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Implement logging and monitoring endpoints',            'InActive', '2024-09-09', '2024-09-20', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Add Swagger documentation and SDK generation',         'InActive', '2024-09-23', '2024-10-04', 25, 25, 3);
Insert Into Sprint (Goal, SprintStatus, StartDate, EndDate, EarnedPoints, TotalPoints, ProjectID) Values ('Load testing and production hardening',                'Active',   '2024-10-07', null,         0,  25, 3);

-- =============================================
-- TICKETS: 5 per sprint = 150 total
-- Completed sprints (1-9, 11-19, 21-29): all 5 tickets are Done with ClosedDate within sprint range
-- Active sprints (10, 20, 30): all 5 tickets are In-Progress or In-Review with ClosedDate null
-- =============================================

-- =============================================
-- PROJECT 1: Website Redesign (ProjectID=1)
-- Team: Alice(1)=ScrumLeader, Dan(2)=Dev, Grace(3)=QA
-- =============================================

-- Sprint 1 (SprintID=1) 2024-06-03 to 2024-06-14 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Initialize Next.js project with TypeScript configuration', 5, 'High', '2024-06-03', '2024-06-07', 'Done', 2, 3, 1, 1);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up Tailwind CSS and design token system', 5, 'High', '2024-06-03', '2024-06-08', 'Done', 2, 3, 1, 1);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create base layout component with header and footer slots', 5, 'Medium', '2024-06-03', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Configure ESLint and Prettier with project rules', 5, 'Medium', '2024-06-03', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up CI pipeline with GitHub Actions for linting and tests', 5, 'Low', '2024-06-03', null, 'Backlog', null, 3, 1, null);

-- Sprint 2 (SprintID=2) 2024-06-17 to 2024-06-28 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build responsive navigation bar with dropdown menus', 5, 'High', '2024-06-17', '2024-06-21', 'Done', 2, 3, 1, 2);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement mobile hamburger menu with slide-out panel', 5, 'High', '2024-06-17', '2024-06-22', 'Done', 2, 3, 1, 2);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create sticky header with scroll-based show/hide behavior', 5, 'Medium', '2024-06-17', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add breadcrumb navigation component', 5, 'Medium', '2024-06-17', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write unit tests for navigation components', 5, 'Low', '2024-06-17', null, 'Backlog', null, 3, 1, null);

-- Sprint 3 (SprintID=3) 2024-07-01 to 2024-07-12 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Design and build hero section with animated background', 5, 'High', '2024-07-01', '2024-07-05', 'Done', 2, 3, 1, 3);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create feature highlights grid with icon cards', 5, 'High', '2024-07-01', '2024-07-06', 'Done', 2, 3, 1, 3);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build testimonials carousel with auto-rotation', 5, 'Medium', '2024-07-01', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add call-to-action banner with email signup', 5, 'Medium', '2024-07-01', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement lazy loading for homepage images', 5, 'Low', '2024-07-01', null, 'Backlog', null, 3, 1, null);

-- Sprint 4 (SprintID=4) 2024-07-15 to 2024-07-26 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build footer with sitemap links and social icons', 5, 'High', '2024-07-15', '2024-07-19', 'Done', 2, 3, 1, 4);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add responsive grid breakpoints for tablet and mobile', 5, 'High', '2024-07-15', '2024-07-20', 'Done', 2, 3, 1, 4);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create newsletter subscription widget in footer', 5, 'Medium', '2024-07-15', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement cookie consent banner', 5, 'Medium', '2024-07-15', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Fix cross-browser rendering issues on Safari and Firefox', 5, 'Low', '2024-07-15', null, 'Backlog', null, 3, 1, null);

-- Sprint 5 (SprintID=5) 2024-07-29 to 2024-08-09 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build contact form with validation and submission handling', 5, 'High', '2024-07-29', '2024-08-02', 'Done', 2, 3, 1, 5);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create about page with team section and company timeline', 5, 'High', '2024-07-29', '2024-08-04', 'Done', 2, 3, 1, 5);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add Google Maps embed for office location', 5, 'Medium', '2024-07-29', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement form spam protection with reCAPTCHA', 5, 'Medium', '2024-07-29', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write integration tests for contact form submission', 5, 'Low', '2024-07-29', null, 'Backlog', null, 3, 1, null);

-- Sprint 6 (SprintID=6) 2024-08-12 to 2024-08-23 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build blog listing page with pagination', 5, 'High', '2024-08-12', '2024-08-16', 'Done', 2, 3, 1, 6);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create blog detail page with rich text rendering', 5, 'High', '2024-08-12', '2024-08-17', 'Done', 2, 3, 1, 6);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add blog categories and tag filtering', 5, 'Medium', '2024-08-12', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement social sharing buttons on blog posts', 5, 'Medium', '2024-08-12', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add related posts sidebar widget', 5, 'Low', '2024-08-12', null, 'Backlog', null, 3, 1, null);

-- Sprint 7 (SprintID=7) 2024-08-26 to 2024-09-06 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement site-wide search with Algolia integration', 5, 'High', '2024-08-26', '2024-08-30', 'Done', 2, 3, 1, 7);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build search results page with highlighted matches', 5, 'High', '2024-08-26', '2024-09-01', 'Done', 2, 3, 1, 7);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add autocomplete suggestions dropdown', 5, 'Medium', '2024-08-26', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement filter sidebar with checkboxes and date ranges', 5, 'Medium', '2024-08-26', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write end-to-end tests for search functionality', 5, 'Low', '2024-08-26', null, 'Backlog', null, 3, 1, null);

-- Sprint 8 (SprintID=8) 2024-09-09 to 2024-09-20 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build login page with email and social auth options', 5, 'High', '2024-09-09', '2024-09-13', 'Done', 2, 3, 1, 8);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create registration page with form validation', 5, 'High', '2024-09-09', '2024-09-14', 'Done', 2, 3, 1, 8);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement forgot password flow with email reset', 5, 'Medium', '2024-09-09', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add user profile page with avatar upload', 5, 'Medium', '2024-09-09', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write security tests for authentication flows', 5, 'Low', '2024-09-09', null, 'Backlog', null, 3, 1, null);

-- Sprint 9 (SprintID=9) 2024-09-23 to 2024-10-04 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Run Lighthouse audit and fix performance issues', 5, 'High', '2024-09-23', '2024-09-27', 'Done', 2, 3, 1, 9);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement code splitting and bundle optimization', 5, 'High', '2024-09-23', '2024-09-28', 'Done', 2, 3, 1, 9);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add ARIA labels and keyboard navigation support', 5, 'Medium', '2024-09-23', null, 'Backlog', null, 3, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Fix color contrast ratios to meet WCAG AA standards', 5, 'Medium', '2024-09-23', null, 'Backlog', null, 1, 1, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Run full accessibility audit with screen reader testing', 5, 'Low', '2024-09-23', null, 'Backlog', null, 3, 1, null);

-- Sprint 10 (SprintID=10) 2024-10-07 to null - ACTIVE
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Configure production environment variables and secrets', 5, 'High', '2024-10-07', null, 'In-Progress', 2, 2, 1, 10);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up CDN and asset caching for static resources', 5, 'High', '2024-10-07', null, 'In-Progress', 2, 2, 1, 10);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create staging to production deployment pipeline', 5, 'Medium', '2024-10-07', null, 'In-Review', 2, 3, 1, 10);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write final QA checklist and run smoke tests', 5, 'Medium', '2024-10-07', null, 'In-Review', 3, 3, 1, 10);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Prepare launch day communication and rollback plan', 5, 'Low', '2024-10-07', null, 'In-Progress', 1, 1, 1, 10);

-- =============================================
-- PROJECT 2: Mobile App (ProjectID=2)
-- Team: Bob(4)=ScrumLeader, Eve(5)=Dev, Hank(6)=QA
-- =============================================

-- Sprint 11 (SprintID=11) 2024-06-03 to 2024-06-14 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Initialize React Native project with Expo configuration', 5, 'High', '2024-06-03', '2024-06-07', 'Done', 5, 6, 2, 11);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up React Navigation with bottom tab navigator', 5, 'High', '2024-06-03', '2024-06-08', 'Done', 5, 6, 2, 11);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create shared UI component library with themed styles', 5, 'Medium', '2024-06-03', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Configure TypeScript paths and module aliases', 5, 'Medium', '2024-06-03', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up Jest and React Native Testing Library', 5, 'Low', '2024-06-03', null, 'Backlog', null, 6, 2, null);

-- Sprint 12 (SprintID=12) 2024-06-17 to 2024-06-28 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build registration screen with form validation', 5, 'High', '2024-06-17', '2024-06-21', 'Done', 5, 6, 2, 12);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement login screen with biometric auth option', 5, 'High', '2024-06-17', '2024-06-22', 'Done', 5, 6, 2, 12);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create secure token storage with Keychain/Keystore', 5, 'Medium', '2024-06-17', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add social login with Google and Apple Sign-In', 5, 'Medium', '2024-06-17', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write auth flow integration tests', 5, 'Low', '2024-06-17', null, 'Backlog', null, 6, 2, null);

-- Sprint 13 (SprintID=13) 2024-07-01 to 2024-07-12 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build home feed with infinite scroll and pull-to-refresh', 5, 'High', '2024-07-01', '2024-07-05', 'Done', 5, 6, 2, 13);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement API service layer with Axios interceptors', 5, 'High', '2024-07-01', '2024-07-06', 'Done', 5, 6, 2, 13);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add loading skeletons and error state components', 5, 'Medium', '2024-07-01', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create feed item detail screen with comments section', 5, 'Medium', '2024-07-01', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write unit tests for data fetching hooks', 5, 'Low', '2024-07-01', null, 'Backlog', null, 6, 2, null);

-- Sprint 14 (SprintID=14) 2024-07-15 to 2024-07-26 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build user profile screen with editable fields', 5, 'High', '2024-07-15', '2024-07-19', 'Done', 5, 6, 2, 14);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create settings screen with notification preferences', 5, 'High', '2024-07-15', '2024-07-20', 'Done', 5, 6, 2, 14);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement dark mode toggle with theme persistence', 5, 'Medium', '2024-07-15', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add account deletion flow with confirmation dialog', 5, 'Medium', '2024-07-15', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write snapshot tests for profile and settings screens', 5, 'Low', '2024-07-15', null, 'Backlog', null, 6, 2, null);

-- Sprint 15 (SprintID=15) 2024-07-29 to 2024-08-09 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Integrate Firebase Cloud Messaging for push notifications', 5, 'High', '2024-07-29', '2024-08-02', 'Done', 5, 6, 2, 15);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement deep linking with React Navigation', 5, 'High', '2024-07-29', '2024-08-04', 'Done', 5, 6, 2, 15);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create notification center screen with read/unread states', 5, 'Medium', '2024-07-29', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add notification badge to tab bar icon', 5, 'Medium', '2024-07-29', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Test push notifications on iOS and Android devices', 5, 'Low', '2024-07-29', null, 'Backlog', null, 6, 2, null);

-- Sprint 16 (SprintID=16) 2024-08-12 to 2024-08-23 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement SQLite local database for offline data caching', 5, 'High', '2024-08-12', '2024-08-16', 'Done', 5, 6, 2, 16);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build sync engine to reconcile local and remote data', 5, 'High', '2024-08-12', '2024-08-17', 'Done', 5, 6, 2, 16);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add network status indicator and offline banner', 5, 'Medium', '2024-08-12', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement queue for pending actions during offline mode', 5, 'Medium', '2024-08-12', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write tests for offline sync conflict resolution', 5, 'Low', '2024-08-12', null, 'Backlog', null, 6, 2, null);

-- Sprint 17 (SprintID=17) 2024-08-26 to 2024-09-06 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build real-time chat UI with message bubbles', 5, 'High', '2024-08-26', '2024-08-30', 'Done', 5, 6, 2, 17);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement WebSocket connection for live messaging', 5, 'High', '2024-08-26', '2024-09-01', 'Done', 5, 6, 2, 17);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add typing indicators and read receipts', 5, 'Medium', '2024-08-26', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create conversation list screen with last message preview', 5, 'Medium', '2024-08-26', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write load tests for WebSocket connections', 5, 'Low', '2024-08-26', null, 'Backlog', null, 6, 2, null);

-- Sprint 18 (SprintID=18) 2024-09-09 to 2024-09-20 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build image picker with camera and gallery options', 5, 'High', '2024-09-09', '2024-09-13', 'Done', 5, 6, 2, 18);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement image compression and upload to S3', 5, 'High', '2024-09-09', '2024-09-14', 'Done', 5, 6, 2, 18);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add image caching with progressive loading', 5, 'Medium', '2024-09-09', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create image gallery viewer with pinch-to-zoom', 5, 'Medium', '2024-09-09', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Test media upload on low bandwidth connections', 5, 'Low', '2024-09-09', null, 'Backlog', null, 6, 2, null);

-- Sprint 19 (SprintID=19) 2024-09-23 to 2024-10-04 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Integrate Mixpanel analytics SDK for event tracking', 5, 'High', '2024-09-23', '2024-09-27', 'Done', 5, 6, 2, 19);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up Sentry for crash reporting and error tracking', 5, 'High', '2024-09-23', '2024-09-28', 'Done', 5, 6, 2, 19);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add screen view tracking and user flow analytics', 5, 'Medium', '2024-09-23', null, 'Backlog', null, 6, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement performance monitoring for API response times', 5, 'Medium', '2024-09-23', null, 'Backlog', null, 4, 2, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Verify analytics events fire correctly across all screens', 5, 'Low', '2024-09-23', null, 'Backlog', null, 6, 2, null);

-- Sprint 20 (SprintID=20) 2024-10-07 to null - ACTIVE
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Prepare App Store metadata and screenshots', 5, 'High', '2024-10-07', null, 'In-Progress', 5, 5, 2, 20);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Configure Google Play Store listing and assets', 5, 'High', '2024-10-07', null, 'In-Progress', 5, 5, 2, 20);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Run full regression test suite on both platforms', 5, 'Medium', '2024-10-07', null, 'In-Review', 6, 6, 2, 20);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Fix critical bugs found during final testing round', 5, 'Medium', '2024-10-07', null, 'In-Progress', 5, 6, 2, 20);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create beta release for internal stakeholder review', 5, 'Low', '2024-10-07', null, 'In-Review', 4, 4, 2, 20);

-- =============================================
-- PROJECT 3: API Gateway (ProjectID=3)
-- Team: Carol(7)=ScrumLeader, Frank(8)=Dev, Ivy(9)=QA
-- =============================================

-- Sprint 21 (SprintID=21) 2024-06-03 to 2024-06-14 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Initialize Express.js project with TypeScript and folder structure', 5, 'High', '2024-06-03', '2024-06-07', 'Done', 8, 9, 3, 21);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Design RESTful API route architecture and conventions', 5, 'High', '2024-06-03', '2024-06-08', 'Done', 8, 9, 3, 21);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up error handling middleware with structured responses', 5, 'Medium', '2024-06-03', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Configure request logging with Morgan and Winston', 5, 'Medium', '2024-06-03', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up Supertest for API endpoint testing', 5, 'Low', '2024-06-03', null, 'Backlog', null, 9, 3, null);

-- Sprint 22 (SprintID=22) 2024-06-17 to 2024-06-28 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement JWT token generation and verification', 5, 'High', '2024-06-17', '2024-06-21', 'Done', 8, 9, 3, 22);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build authentication middleware for protected routes', 5, 'High', '2024-06-17', '2024-06-22', 'Done', 8, 9, 3, 22);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create role-based access control system', 5, 'Medium', '2024-06-17', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add refresh token rotation logic', 5, 'Medium', '2024-06-17', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write security tests for auth middleware', 5, 'Low', '2024-06-17', null, 'Backlog', null, 9, 3, null);

-- Sprint 23 (SprintID=23) 2024-07-01 to 2024-07-12 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build CRUD endpoints for users resource', 5, 'High', '2024-07-01', '2024-07-05', 'Done', 8, 9, 3, 23);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build CRUD endpoints for projects resource', 5, 'High', '2024-07-01', '2024-07-06', 'Done', 8, 9, 3, 23);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build CRUD endpoints for tickets resource', 5, 'Medium', '2024-07-01', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement pagination and sorting for list endpoints', 5, 'Medium', '2024-07-01', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write integration tests for all CRUD operations', 5, 'Low', '2024-07-01', null, 'Backlog', null, 9, 3, null);

-- Sprint 24 (SprintID=24) 2024-07-15 to 2024-07-26 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement token bucket rate limiting algorithm', 5, 'High', '2024-07-15', '2024-07-19', 'Done', 8, 9, 3, 24);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add request body validation with Joi schemas', 5, 'High', '2024-07-15', '2024-07-20', 'Done', 8, 9, 3, 24);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create IP-based throttling for abuse prevention', 5, 'Medium', '2024-07-15', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add request sanitization to prevent XSS and injection', 5, 'Medium', '2024-07-15', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write load tests for rate limiting thresholds', 5, 'Low', '2024-07-15', null, 'Backlog', null, 9, 3, null);

-- Sprint 25 (SprintID=25) 2024-07-29 to 2024-08-09 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up Redis for response caching with TTL config', 5, 'High', '2024-07-29', '2024-08-02', 'Done', 8, 9, 3, 25);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement cache invalidation on data mutations', 5, 'High', '2024-07-29', '2024-08-04', 'Done', 8, 9, 3, 25);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add ETag support for conditional GET requests', 5, 'Medium', '2024-07-29', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create cache health monitoring endpoint', 5, 'Medium', '2024-07-29', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write performance benchmarks for cached vs uncached', 5, 'Low', '2024-07-29', null, 'Backlog', null, 9, 3, null);

-- Sprint 26 (SprintID=26) 2024-08-12 to 2024-08-23 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build webhook registration and management endpoints', 5, 'High', '2024-08-12', '2024-08-16', 'Done', 8, 9, 3, 26);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement event dispatcher with retry logic', 5, 'High', '2024-08-12', '2024-08-17', 'Done', 8, 9, 3, 26);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add webhook signature verification for security', 5, 'Medium', '2024-08-12', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create webhook delivery logs and status dashboard', 5, 'Medium', '2024-08-12', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write end-to-end tests for webhook delivery flow', 5, 'Low', '2024-08-12', null, 'Backlog', null, 9, 3, null);

-- Sprint 27 (SprintID=27) 2024-08-26 to 2024-09-06 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement URL-based API versioning with v1/v2 routing', 5, 'High', '2024-08-26', '2024-08-30', 'Done', 8, 9, 3, 27);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build version negotiation via Accept header', 5, 'High', '2024-08-26', '2024-09-01', 'Done', 8, 9, 3, 27);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add deprecation warning headers for old API versions', 5, 'Medium', '2024-08-26', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create migration guide documentation for version upgrades', 5, 'Medium', '2024-08-26', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write backward compatibility tests across versions', 5, 'Low', '2024-08-26', null, 'Backlog', null, 9, 3, null);

-- Sprint 28 (SprintID=28) 2024-09-09 to 2024-09-20 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement structured JSON logging with correlation IDs', 5, 'High', '2024-09-09', '2024-09-13', 'Done', 8, 9, 3, 28);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create health check and readiness probe endpoints', 5, 'High', '2024-09-09', '2024-09-14', 'Done', 8, 9, 3, 28);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add Prometheus metrics endpoint for monitoring', 5, 'Medium', '2024-09-09', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Implement request tracing with OpenTelemetry', 5, 'Medium', '2024-09-09', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Write tests for logging output format and levels', 5, 'Low', '2024-09-09', null, 'Backlog', null, 9, 3, null);

-- Sprint 29 (SprintID=29) 2024-09-23 to 2024-10-04 - COMPLETED
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Generate Swagger/OpenAPI specification from route definitions', 5, 'High', '2024-09-23', '2024-09-27', 'Done', 8, 9, 3, 29);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Build interactive API documentation page with Swagger UI', 5, 'High', '2024-09-23', '2024-09-28', 'Done', 8, 9, 3, 29);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Auto-generate TypeScript SDK from OpenAPI spec', 5, 'Medium', '2024-09-23', null, 'Backlog', null, 9, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Add example requests and responses to documentation', 5, 'Medium', '2024-09-23', null, 'Backlog', null, 7, 3, null);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Validate OpenAPI spec against industry standards', 5, 'Low', '2024-09-23', null, 'Backlog', null, 9, 3, null);

-- Sprint 30 (SprintID=30) 2024-10-07 to null - ACTIVE
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Run k6 load tests and identify performance bottlenecks', 5, 'High', '2024-10-07', null, 'In-Progress', 8, 8, 3, 30);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Optimize database queries and add connection pooling', 5, 'High', '2024-10-07', null, 'In-Progress', 8, 8, 3, 30);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Configure auto-scaling rules and resource limits', 5, 'Medium', '2024-10-07', null, 'In-Review', 8, 9, 3, 30);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Set up disaster recovery and failover procedures', 5, 'Medium', '2024-10-07', null, 'In-Review', 8, 9, 3, 30);
Insert Into Ticket (TicketDescription, Points, TicketPriority, CreatedDate, ClosedDate, TicketStatus, AssignedToUser, LastModifiedByUser, ProjectID, SprintID) Values ('Create production runbook and incident response plan', 5, 'Low', '2024-10-07', null, 'In-Progress', 7, 7, 3, 30);