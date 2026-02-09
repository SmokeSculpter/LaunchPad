using LaunchPadApi.DTO;

namespace LaunchPadApi.Views
{
    public class DashboardView
    {
        public required SprintDTO ActiveSprint { get; set; }

        public required List<SprintCount> SprintTicketCounts { get; set; }

        public required List<TicketDTO> BackLogTickets { get; set; }

        public required List<TicketDTO> ScrumHistoryTickets { get; set; }
    }
}
