using LaunchPadApi.DTO;
using LaunchPadApi.Models;
using Microsoft.EntityFrameworkCore;

namespace LaunchPadApi.Services
{
    public interface ITicketServices
    {
        Task<List<SprintTicketCountByStatus>> GetSprintTicketCountByUser(int userId);
    }

    public class TicketServices : ITicketServices
    {
        private readonly LaunchPadContext _context;

        TicketServices(LaunchPadContext context)
        {
            _context = context;
        }

        public async Task<List<SprintTicketCountByStatus>> GetSprintTicketCountByUser(int userId)
        {
            if (userId == 0)
            {
                throw new ArgumentException("Must provide a user id.");
            }

            List<SprintTicketCountByStatus> ticketCounts = await _context.Tickets
                .GroupBy(ticket => ticket.TicketStatus)
                .Select(ticketgroup => new SprintTicketCountByStatus
                    {
                        Status = ticketgroup.Key,
                        Count = ticketgroup.Count()
                    }
                ).ToListAsync();

            if (ticketCounts.Count < 4)
            {
                throw new Exception();
            }

            return ticketCounts;
        }
    }
}
