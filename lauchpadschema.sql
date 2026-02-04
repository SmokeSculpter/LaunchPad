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