using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class Ticket
{
    public int TicketId { get; set; }

    public string TicketDescription { get; set; } = null!;

    public string TicketType { get; set; } = null!;

    public int Points { get; set; }

    public string TicketPriority { get; set; } = null!;

    public DateOnly CreatedDate { get; set; }

    public DateOnly? ClosedDate { get; set; }

    public string TicketStatus { get; set; } = null!;

    public int? AssignedToUser { get; set; }

    public int? LastModifiedByUser { get; set; }

    public int ProjectId { get; set; }

    public int? SprintId { get; set; }

    public virtual PadUser? AssignedToUserNavigation { get; set; }

    public virtual ICollection<Assignment> Assignments { get; set; } = new List<Assignment>();

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual PadUser? LastModifiedByUserNavigation { get; set; }

    public virtual Project Project { get; set; } = null!;

    public virtual Sprint? Sprint { get; set; }

    public virtual ICollection<Task> Tasks { get; set; } = new List<Task>();

    public virtual ICollection<TicketLog> TicketLogs { get; set; } = new List<TicketLog>();
}
