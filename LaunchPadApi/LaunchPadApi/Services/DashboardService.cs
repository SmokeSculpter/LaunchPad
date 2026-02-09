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

            if (userRole == null || activeSprint == null)
            {
                throw new Exception("Failed to fetch user or active sprint");
            }

            List<SprintCount> sprintTicketsCount;

            if (userRole.Role.Title == "QA" || userRole.Role.Title == "Developer")
            {
                sprintTicketsCount = await _context.Tickets
                    .GroupBy(ticket => ticket.TicketStatus)
                    .Select(ticketGroup => new SprintCount
                        {
                            Status = ticketGroup.Key,
                            Count = ticketGroup.Where(ticket => ticket.Sprint != null && ticket.AssignedToUser == userId).Count()
                        }
                    ).ToListAsync();
            }
            else
            {
                sprintTicketsCount = await _context.Tickets
                    .GroupBy(ticket => ticket.TicketStatus)
                    .Select(ticketGroup => new SprintCount
                        {
                            Status = ticketGroup.Key,
                            Count = ticketGroup.Where(ticket => ticket.Sprint != null).Count()
                        }
                    ).ToListAsync();
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

            if (sprintTicketsCount == null || sprintTicketsCount.Count() != 4)
            {
                throw new Exception("Sprint Ticket Count is wrong");
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
