namespace LaunchPadApi.DTO
{
    public class TicketDTO
    {
        public required int TicketId { get; set; }

        public string Description { get; set; } = string.Empty;

        public required string Type { get; set; }

        public required int Points { get; set; }

        public required string Priority { get; set; }

        public required DateOnly CreatedDate { get; set; }

        public DateOnly? DateClosed { get; set; } = null;

        public required string Status { get; set; }

        public required int? AssignedToUser { get; set; } = null;

        public required int? LastModifiedByUser { get; set; } = null;

        public required int ProjectId { get; set; }
    }
}
