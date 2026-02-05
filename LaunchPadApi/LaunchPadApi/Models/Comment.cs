using System;
using System.Collections.Generic;

namespace LaunchPadApi.Models;

public partial class Comment
{
    public int CommentId { get; set; }

    public DateOnly CommentDate { get; set; }

    public string Content { get; set; } = null!;

    public int? ParentCommentId { get; set; }

    public int UserId { get; set; }

    public int TicketId { get; set; }

    public virtual ICollection<Comment> InverseParentComment { get; set; } = new List<Comment>();

    public virtual Comment? ParentComment { get; set; }

    public virtual Ticket Ticket { get; set; } = null!;

    public virtual PadUser User { get; set; } = null!;
}
