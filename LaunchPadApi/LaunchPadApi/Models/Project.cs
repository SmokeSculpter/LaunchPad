using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class Project
{
    public int ProjectId { get; set; }

    public string ProjectName { get; set; } = null!;

    public string ProjectDescription { get; set; } = null!;

    public DateOnly DateStarted { get; set; }

    public DateOnly? DateClosed { get; set; }

    public int OrganizationId { get; set; }

    public virtual Organization Organization { get; set; } = null!;

    public virtual ICollection<ProjectMember> ProjectMembers { get; set; } = new List<ProjectMember>();

    public virtual ICollection<Sprint> Sprints { get; set; } = new List<Sprint>();

    public virtual ICollection<Ticket> Tickets { get; set; } = new List<Ticket>();
}
