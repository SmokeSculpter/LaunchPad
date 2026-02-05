using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class TicketLog
{
    public int TicketLogId { get; set; }

    public string OldStatus { get; set; } = null!;

    public string NewStatus { get; set; } = null!;

    public DateOnly DateCreated { get; set; }

    public string? Note { get; set; }

    public int UserId { get; set; }

    public int TicketId { get; set; }

    public virtual Ticket Ticket { get; set; } = null!;

    public virtual PadUser User { get; set; } = null!;
}
