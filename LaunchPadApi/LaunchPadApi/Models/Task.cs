using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class Task
{
    public int TaskId { get; set; }

    public string Title { get; set; } = null!;

    public string TaskDescription { get; set; } = null!;

    public string TaskPriority { get; set; } = null!;

    public int OrderValue { get; set; }

    public string TaskStatus { get; set; } = null!;

    public int? TicketId { get; set; }

    public virtual Ticket? Ticket { get; set; }
}
