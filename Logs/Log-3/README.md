# LaunchPad
A project management app currently in early development.

## February 4th (Log 3)
Finalized the database schema and created the SQL script to build the database.

### WebSocket Integration
Created the LaunchPadApi back-end project and successfully added WebSocket functionality. Next we will setup authorization with Clerk and authorize each request. Proper configuration in Program.cs is important, as well as the order these methods are called.
```csharp
builder.Services.AddSignalR();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:5173", "https://localhost:5173")
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
    });
});

app.MapHub<TestHub>("/testSocket");
```
Then we can initialize both hub and database contexts and handle events on the socket.
```csharp
public async Task<IActionResult> Send()
{
    var users = await _context.PadUsers.Select(user => new
    {
        Name = user.FirstName + " " + user.LastName
    }).ToListAsync();
    await _hubContext.Clients.All.SendAsync("UpdateUsers", users);
    return Ok();
}
```
Then set it up client-side.
```js
import './style.css'
import * as signalR from "@microsoft/signalr";


const connection = new signalR.HubConnectionBuilder()
  .withUrl("https://localhost:7196/testSocket")
  .build();

connection.on("UpdateUsers", (message) => {
  console.log(message);
})


connection.start().then(() => console.log("Connected!"))
  .catch(err => console.error(err));
```
And we have our data.
```json
[
    { "name": "Alice Johnson" },
    { "name": "Bob Smith" },
    { "name": "Carol Williams" },
]
```

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
- `launchpadschema.sql` - Complete SQL Server script to create all tables with constraints and relationships, indexes for faster data retrieval, and insert statements containing dummy data created with AI.
