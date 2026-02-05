using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class PadUser
{
    public int UserId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Password { get; set; } = null!;

    public string? Phone { get; set; }

    public int RoleId { get; set; }

    public virtual ICollection<Assignment> Assignments { get; set; } = new List<Assignment>();

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual ICollection<ProjectMember> ProjectMembers { get; set; } = new List<ProjectMember>();

    public virtual UserRole Role { get; set; } = null!;

    public virtual ICollection<Ticket> TicketAssignedToUserNavigations { get; set; } = new List<Ticket>();

    public virtual ICollection<Ticket> TicketLastModifiedByUserNavigations { get; set; } = new List<Ticket>();

    public virtual ICollection<TicketLog> TicketLogs { get; set; } = new List<TicketLog>();
}
