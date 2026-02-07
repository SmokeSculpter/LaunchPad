using LaunchPadApi.DTO;
using LaunchPadApi.Models;
using LaunchPadApi.Views;
using Microsoft.EntityFrameworkCore;
using Task = System.Threading.Tasks.Task;

namespace LaunchPadApi.Services
{
    public interface IDashboardService
    {
        Task<DashboardView> Get_Dash_View(int userId);
    }

    public class DashboardService : IDashboardService
    {
        private readonly LaunchPadContext _context;

        public DashboardService(LaunchPadContext context)
        {
            _context = context;
        }

        public async Task<DashboardView> Get_Dash_View(int userId) 
        {

            if (userId == 0)
            {
                throw new ArgumentNullException("Need to provide a UserId");
            }

           var userRole = await _context.PadUsers.Where(user => user.UserId == userId).Select(user => new { user.Role }).FirstOrDefaultAsync();

           var activeSprint = await _context.Sprints
               .Where(sprint => sprint.SprintStatus == "Active")
               .Select(sprint => new SprintDTO
               {
                     SprintId = sprint.SprintId,
                     Goal = sprint.Goal,
                     SprintStatus = sprint.SprintStatus,
                     StartDate = sprint.StartDate,
                     EndDate = sprint.EndDate,
                     EarnedPoints = sprint.EarnedPoints,
                     TotalPoints = sprint.TotalPoints,
                     ProjectId = sprint.ProjectId
                })
                .FirstOrDefaultAsync();

            List<int> sprintTicketsCount = new List<int>();

            if (userRole.Role.Title == "QA" || userRole.Role.Title == "Developer")
            {
                sprintTicketsCount = new List<int>
                {
                    _context.Tickets.Where(ticket => ticket.TicketStatus == "To-Do" && ticket.AssignedToUser == userId && ticket.SprintId != null).Count(),
                    _context.Tickets.Where(ticket => ticket.TicketStatus == "In-Progress" && ticket.AssignedToUser == userId && ticket.SprintId != null).Count(),
                    _context.Tickets.Where(ticket => ticket.TicketStatus == "In-Review" && ticket.AssignedToUser == userId && ticket.SprintId != null).Count(),
                    _context.Tickets.Where(ticket => ticket.TicketStatus == "Done" && ticket.AssignedToUser == userId && ticket.SprintId != null).Count()
                };
            }
            else
            {
                sprintTicketsCount = new List<int>
                {
                    _context.Tickets.Where(ticket => ticket.TicketStatus == "To-Do" && ticket.SprintId != null).Count(),
                    _context.Tickets.Where(ticket => ticket.TicketStatus == "In-Progress" && ticket.SprintId != null).Count(),
                    _context.Tickets.Where(ticket => ticket.TicketStatus == "In-Review" && ticket.SprintId != null).Count(),
                    _context.Tickets.Where(ticket => ticket.TicketStatus == "Done" && ticket.SprintId != null).Count()
                };
            }


                var backlogTickets = await _context.Tickets
                    .Where(ticket => ticket.TicketStatus == "Backlog")
                    .Select(ticket => new TicketDTO
                    {
                        TicketId = ticket.TicketId,
                        Description = ticket.TicketDescription,
                        Type = ticket.TicketType,
                        Points = ticket.Points,
                        Priority = ticket.TicketPriority,
                        CreatedDate = ticket.CreatedDate,
                        DateClosed = ticket.ClosedDate,
                        Status = ticket.TicketStatus,
                        AssignedToUser = ticket.AssignedToUser,
                        LastModifiedByUser = ticket.LastModifiedByUser,
                        ProjectId = ticket.ProjectId
                    })
                     .ToListAsync();

            var scrumHistoryTickets = await _context.Tickets
               .Where(ticket => ticket.SprintId == null)
               .Select(ticket => new TicketDTO
               {
                    TicketId = ticket.TicketId,
                    Description = ticket.TicketDescription,
                    Type = ticket.TicketType,
                    Points = ticket.Points,
                    Priority = ticket.TicketPriority,
                    CreatedDate = ticket.CreatedDate,
                    DateClosed = ticket.ClosedDate,
                    Status = ticket.TicketStatus,
                    AssignedToUser = ticket.AssignedToUser,
                    LastModifiedByUser = ticket.LastModifiedByUser,
                    ProjectId = ticket.ProjectId
                })
                .ToListAsync();

            if (sprintTicketsCount == null || sprintTicketsCount.Count == 0)
            {
                throw new Exception("Sprint Ticket Count is null");
            }
            if (backlogTickets.Count == 0)
            {
                throw new Exception("Backlog tickets is null");
            }
            if (scrumHistoryTickets.Count == 0)
            {
                throw new Exception("Sprint Ticket History is null");
            }
            if (activeSprint == null)
            {
                throw new Exception("Active Sprint is null");
            }

            return new DashboardView 
            {
                ActiveSprint = activeSprint,
                SprintTicketCounts = sprintTicketsCount,
                BackLogTickets = backlogTickets,
                ScrumHistoryTickets = scrumHistoryTickets
            };
        }
    }
}
