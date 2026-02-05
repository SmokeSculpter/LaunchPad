using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class UserRole
{
    public int RoleId { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<PadUser> PadUsers { get; set; } = new List<PadUser>();
}
