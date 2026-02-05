using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class Assignment
{
    public int AssignmentId { get; set; }

    public DateOnly DateAssigned { get; set; }

    public DateOnly? DateStarted { get; set; }

    public DateOnly? DateFinished { get; set; }

    public int UserId { get; set; }

    public int TicketId { get; set; }

    public virtual Ticket Ticket { get; set; } = null!;

    public virtual PadUser User { get; set; } = null!;
}
