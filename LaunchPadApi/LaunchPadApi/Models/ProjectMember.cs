using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class ProjectMember
{
    public int ProjectMemberId { get; set; }

    public int UserId { get; set; }

    public int ProjectId { get; set; }

    public virtual Project Project { get; set; } = null!;

    public virtual PadUser User { get; set; } = null!;
}
