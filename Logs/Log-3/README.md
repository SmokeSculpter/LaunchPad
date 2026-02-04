# LaunchPad
A project management app currently in early development.

## February 4th (Log 3)
Finalized the database schema and created the SQL script to build the database.

### Database Schema Finalization
Reviewed the ERD from Log-2 against the planned features and made the following decisions:

#### Tables Created (11 total):
1. **UserRole** - Stores role definitions (e.g., Software Dev, QA, Project Manager)
2. **PadUser** - User accounts with role assignment
3. **Organization** - Organizations that own projects
4. **Project** - Projects belonging to organizations
5. **ProjectMember** - Junction table linking users to projects
6. **Sprint** - Sprint/iteration tracking with goals and points
7. **Ticket** - Main work items with priority, status, and assignment
8. **Task** - Subtasks belonging to tickets
9. **Assignment** - Tracks ticket assignment history
10. **TicketLog** - Audit trail for ticket status changes
11. **Comment** - Threaded comments on tickets

#### Key Design Decisions:
- **Ticket has both ProjectID and SprintID** - Allows tickets to exist in backlog (SprintID = null) while still belonging to a project
- **Single user assignment** - One user assigned to a ticket at a time (AssignedToUser), with Assignment table tracking history
- **Status enums with CHECK constraints** - Enforces valid statuses: `Backlog`, `To-Do`, `In-Progress`, `In-Review`, `Done`
- **Priority enums** - `Low`, `Medium`, `High` with default of `Medium`
- **Sprint status** - `Planning`, `Active`, `InActive`
- **Self-referencing Comment table** - Supports threaded discussions via ParentCommentID
- **LastModifiedByUser on Ticket** - Tracks who last modified each ticket for audit purposes

#### Workflow Summary:
- Tickets start in `Backlog` status
- Team lead moves tickets to Sprint during sprint planning
- Developer picks up ticket, moves to `In-Progress`
- Developer creates/completes Tasks within the ticket
- When ready, ticket moves to `In-Review` for QA
- QA approves and moves to `Done`, or sends back for rework

### Files Created:
- `lauchpadschema.sql` - Complete SQL Server script to create all tables with constraints and relationships, indexes for faster data retrieval, and added insert statements containing dummy data created with AI.
