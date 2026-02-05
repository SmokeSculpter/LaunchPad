using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace LaunchPadApi.Models;

public partial class LaunchPadContext : DbContext
{
    public LaunchPadContext()
    {
    }

    public LaunchPadContext(DbContextOptions<LaunchPadContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Assignment> Assignments { get; set; }

    public virtual DbSet<Comment> Comments { get; set; }

    public virtual DbSet<Organization> Organizations { get; set; }

    public virtual DbSet<PadUser> PadUsers { get; set; }

    public virtual DbSet<Project> Projects { get; set; }

    public virtual DbSet<ProjectMember> ProjectMembers { get; set; }

    public virtual DbSet<Sprint> Sprints { get; set; }

    public virtual DbSet<Task> Tasks { get; set; }

    public virtual DbSet<Ticket> Tickets { get; set; }

    public virtual DbSet<TicketLog> TicketLogs { get; set; }

    public virtual DbSet<UserRole> UserRoles { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Name=ConnectionStrings:DefaultConnection");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Assignment>(entity =>
        {
            entity.HasKey(e => e.AssignmentId).HasName("PK__Assignme__32499E5716AC7A7E");

            entity.ToTable("Assignment");

            entity.HasIndex(e => e.TicketId, "IX_Assignment_TicketID");

            entity.HasIndex(e => e.UserId, "IX_Assignment_UserID");

            entity.Property(e => e.AssignmentId).HasColumnName("AssignmentID");
            entity.Property(e => e.TicketId).HasColumnName("TicketID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Ticket).WithMany(p => p.Assignments)
                .HasForeignKey(d => d.TicketId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Assignmen__Ticke__0B91BA14");

            entity.HasOne(d => d.User).WithMany(p => p.Assignments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Assignmen__UserI__0A9D95DB");
        });

        modelBuilder.Entity<Comment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__Comment__C3B4DFAA04CB7F84");

            entity.ToTable("Comment");

            entity.HasIndex(e => e.ParentCommentId, "IX_Comment_ParentCommentID");

            entity.HasIndex(e => e.TicketId, "IX_Comment_TicketID");

            entity.Property(e => e.CommentId).HasColumnName("CommentID");
            entity.Property(e => e.Content)
                .HasMaxLength(1000)
                .IsUnicode(false);
            entity.Property(e => e.ParentCommentId).HasColumnName("ParentCommentID");
            entity.Property(e => e.TicketId).HasColumnName("TicketID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.ParentComment).WithMany(p => p.InverseParentComment)
                .HasForeignKey(d => d.ParentCommentId)
                .HasConstraintName("FK__Comment__ParentC__14270015");

            entity.HasOne(d => d.Ticket).WithMany(p => p.Comments)
                .HasForeignKey(d => d.TicketId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Comment__TicketI__160F4887");

            entity.HasOne(d => d.User).WithMany(p => p.Comments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Comment__UserID__151B244E");
        });

        modelBuilder.Entity<Organization>(entity =>
        {
            entity.HasKey(e => e.OrganizationId).HasName("PK__Organiza__CADB0B72F008419C");

            entity.ToTable("Organization");

            entity.Property(e => e.OrganizationId).HasColumnName("OrganizationID");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.OrgName)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Phone)
                .HasMaxLength(13)
                .IsUnicode(false);
        });

        modelBuilder.Entity<PadUser>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__PadUser__1788CCAC3D1C05EC");

            entity.ToTable("PadUser");

            entity.Property(e => e.UserId).HasColumnName("UserID");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.FirstName)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LastName)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Password)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Phone)
                .HasMaxLength(13)
                .IsUnicode(false);
            entity.Property(e => e.RoleId).HasColumnName("RoleID");

            entity.HasOne(d => d.Role).WithMany(p => p.PadUsers)
                .HasForeignKey(d => d.RoleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__PadUser__RoleID__6A30C649");
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.HasKey(e => e.ProjectId).HasName("PK__Project__761ABED0D9839DCE");

            entity.ToTable("Project");

            entity.Property(e => e.ProjectId).HasColumnName("ProjectID");
            entity.Property(e => e.OrganizationId).HasColumnName("OrganizationID");
            entity.Property(e => e.ProjectDescription)
                .HasMaxLength(300)
                .IsUnicode(false);
            entity.Property(e => e.ProjectName)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.Organization).WithMany(p => p.Projects)
                .HasForeignKey(d => d.OrganizationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Project__Organiz__6EF57B66");
        });

        modelBuilder.Entity<ProjectMember>(entity =>
        {
            entity.HasKey(e => e.ProjectMemberId).HasName("PK__ProjectM__E4E9983C45F9A87D");

            entity.ToTable("ProjectMember");

            entity.HasIndex(e => e.ProjectId, "IX_ProjectMember_ProjectID");

            entity.HasIndex(e => e.UserId, "IX_ProjectMember_UserID");

            entity.Property(e => e.ProjectMemberId).HasColumnName("ProjectMemberID");
            entity.Property(e => e.ProjectId).HasColumnName("ProjectID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Project).WithMany(p => p.ProjectMembers)
                .HasForeignKey(d => d.ProjectId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ProjectMe__Proje__72C60C4A");

            entity.HasOne(d => d.User).WithMany(p => p.ProjectMembers)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ProjectMe__UserI__71D1E811");
        });

        modelBuilder.Entity<Sprint>(entity =>
        {
            entity.HasKey(e => e.SprintId).HasName("PK__Sprint__29F16AE0D821F25A");

            entity.ToTable("Sprint");

            entity.HasIndex(e => e.ProjectId, "IX_Sprint_ProjectID");

            entity.Property(e => e.SprintId).HasColumnName("SprintID");
            entity.Property(e => e.Goal)
                .HasMaxLength(300)
                .IsUnicode(false);
            entity.Property(e => e.ProjectId).HasColumnName("ProjectID");
            entity.Property(e => e.SprintStatus)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("Planning");

            entity.HasOne(d => d.Project).WithMany(p => p.Sprints)
                .HasForeignKey(d => d.ProjectId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Sprint__ProjectI__778AC167");
        });

        modelBuilder.Entity<Task>(entity =>
        {
            entity.HasKey(e => e.TaskId).HasName("PK__Task__7C6949D1A4729D82");

            entity.ToTable("Task");

            entity.HasIndex(e => e.TaskStatus, "IX_Task_TaskStatus");

            entity.HasIndex(e => e.TicketId, "IX_Task_TicketID");

            entity.Property(e => e.TaskId).HasColumnName("TaskID");
            entity.Property(e => e.TaskDescription)
                .HasMaxLength(300)
                .IsUnicode(false);
            entity.Property(e => e.TaskPriority)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("Medium");
            entity.Property(e => e.TaskStatus)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("Backlog");
            entity.Property(e => e.TicketId).HasColumnName("TicketID");
            entity.Property(e => e.Title)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.Ticket).WithMany(p => p.Tasks)
                .HasForeignKey(d => d.TicketId)
                .HasConstraintName("FK__Task__TicketID__07C12930");
        });

        modelBuilder.Entity<Ticket>(entity =>
        {
            entity.HasKey(e => e.TicketId).HasName("PK__Ticket__712CC627555BB66C");

            entity.ToTable("Ticket");

            entity.HasIndex(e => e.AssignedToUser, "IX_Ticket_AssignedToUser");

            entity.HasIndex(e => e.ProjectId, "IX_Ticket_ProjectID");

            entity.HasIndex(e => e.SprintId, "IX_Ticket_SprintID");

            entity.HasIndex(e => e.TicketStatus, "IX_Ticket_TicketStatus");

            entity.Property(e => e.TicketId).HasColumnName("TicketID");
            entity.Property(e => e.ProjectId).HasColumnName("ProjectID");
            entity.Property(e => e.SprintId).HasColumnName("SprintID");
            entity.Property(e => e.TicketDescription)
                .HasMaxLength(300)
                .IsUnicode(false);
            entity.Property(e => e.TicketPriority)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("Medium");
            entity.Property(e => e.TicketStatus)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("Backlog");

            entity.HasOne(d => d.AssignedToUserNavigation).WithMany(p => p.TicketAssignedToUserNavigations)
                .HasForeignKey(d => d.AssignedToUser)
                .HasConstraintName("FK__Ticket__Assigned__7E37BEF6");

            entity.HasOne(d => d.LastModifiedByUserNavigation).WithMany(p => p.TicketLastModifiedByUserNavigations)
                .HasForeignKey(d => d.LastModifiedByUser)
                .HasConstraintName("FK__Ticket__LastModi__7F2BE32F");

            entity.HasOne(d => d.Project).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.ProjectId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ticket__ProjectI__00200768");

            entity.HasOne(d => d.Sprint).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.SprintId)
                .HasConstraintName("FK__Ticket__SprintID__01142BA1");
        });

        modelBuilder.Entity<TicketLog>(entity =>
        {
            entity.HasKey(e => e.TicketLogId).HasName("PK__TicketLo__FCB0524AACD85EC2");

            entity.ToTable("TicketLog");

            entity.Property(e => e.TicketLogId).HasColumnName("TicketLogID");
            entity.Property(e => e.NewStatus)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Note)
                .HasMaxLength(300)
                .IsUnicode(false);
            entity.Property(e => e.OldStatus)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.TicketId).HasColumnName("TicketID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Ticket).WithMany(p => p.TicketLogs)
                .HasForeignKey(d => d.TicketId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TicketLog__Ticke__114A936A");

            entity.HasOne(d => d.User).WithMany(p => p.TicketLogs)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TicketLog__UserI__10566F31");
        });

        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__UserRole__8AFACE3A05E76E98");

            entity.ToTable("UserRole");

            entity.Property(e => e.RoleId).HasColumnName("RoleID");
            entity.Property(e => e.Title)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
