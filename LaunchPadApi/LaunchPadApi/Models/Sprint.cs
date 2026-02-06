using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class Sprint
{
    public int SprintId { get; set; }

    public string Goal { get; set; } = null!;

    public string SprintStatus { get; set; } = null!;

    public DateOnly StartDate { get; set; }

    public DateOnly? EndDate { get; set; }

    public int EarnedPoints { get; set; }

    public int TotalPoints { get; set; }

    public int ProjectId { get; set; }

    public virtual Project Project { get; set; } = null!;

    public virtual ICollection<Ticket> Tickets { get; set; } = new List<Ticket>();
}
