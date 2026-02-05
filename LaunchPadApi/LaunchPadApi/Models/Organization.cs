using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class Organization
{
    public int OrganizationId { get; set; }

    public string OrgName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Phone { get; set; }

    public virtual ICollection<Project> Projects { get; set; } = new List<Project>();
}
