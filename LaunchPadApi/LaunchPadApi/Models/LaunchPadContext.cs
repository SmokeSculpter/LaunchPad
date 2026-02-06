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
            entity.HasKey(e => e.AssignmentId).HasName("PK__Assignme__32499E57482E45F4");

            entity.ToTable("Assignment");

            entity.HasIndex(e => e.TicketId, "IX_Assignment_TicketID");

            entity.HasIndex(e => e.UserId, "IX_Assignment_UserID");

            entity.Property(e => e.AssignmentId).HasColumnName("AssignmentID");
            entity.Property(e => e.TicketId).HasColumnName("TicketID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Ticket).WithMany(p => p.Assignments)
                .HasForeignKey(d => d.TicketId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Assignmen__Ticke__3F115E1A");

            entity.HasOne(d => d.User).WithMany(p => p.Assignments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Assignmen__UserI__3E1D39E1");
        });

        modelBuilder.Entity<Comment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__Comment__C3B4DFAA510F6370");

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
                .HasConstraintName("FK__Comment__ParentC__47A6A41B");

            entity.HasOne(d => d.Ticket).WithMany(p => p.Comments)
                .HasForeignKey(d => d.TicketId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Comment__TicketI__498EEC8D");

            entity.HasOne(d => d.User).WithMany(p => p.Comments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Comment__UserID__489AC854");
        });

        modelBuilder.Entity<Organization>(entity =>
        {
            entity.HasKey(e => e.OrganizationId).HasName("PK__Organiza__CADB0B724370C65E");

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
            entity.HasKey(e => e.UserId).HasName("PK__PadUser__1788CCAC0B42B6B7");

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
                .HasConstraintName("FK__PadUser__RoleID__1AD3FDA4");
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.HasKey(e => e.ProjectId).HasName("PK__Project__761ABED0F9F17DF5");

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
                .HasConstraintName("FK__Project__Organiz__1F98B2C1");
        });

        modelBuilder.Entity<ProjectMember>(entity =>
        {
            entity.HasKey(e => e.ProjectMemberId).HasName("PK__ProjectM__E4E9983CAD70B795");

            entity.ToTable("ProjectMember");

            entity.HasIndex(e => e.ProjectId, "IX_ProjectMember_ProjectID");

            entity.HasIndex(e => e.UserId, "IX_ProjectMember_UserID");

            entity.Property(e => e.ProjectMemberId).HasColumnName("ProjectMemberID");
            entity.Property(e => e.ProjectId).HasColumnName("ProjectID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Project).WithMany(p => p.ProjectMembers)
                .HasForeignKey(d => d.ProjectId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ProjectMe__Proje__236943A5");

            entity.HasOne(d => d.User).WithMany(p => p.ProjectMembers)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ProjectMe__UserI__22751F6C");
        });

        modelBuilder.Entity<Sprint>(entity =>
        {
            entity.HasKey(e => e.SprintId).HasName("PK__Sprint__29F16AE0C58187B7");

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
                .HasConstraintName("FK__Sprint__ProjectI__29221CFB");
        });

        modelBuilder.Entity<Task>(entity =>
        {
            entity.HasKey(e => e.TaskId).HasName("PK__Task__7C6949D1AADA3032");

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
                .HasConstraintName("FK__Task__TicketID__3B40CD36");
        });

        modelBuilder.Entity<Ticket>(entity =>
        {
            entity.HasKey(e => e.TicketId).HasName("PK__Ticket__712CC6277C10E1A7");

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
            entity.Property(e => e.TicketType)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("Feature");

            entity.HasOne(d => d.AssignedToUserNavigation).WithMany(p => p.TicketAssignedToUserNavigations)
                .HasForeignKey(d => d.AssignedToUser)
                .HasConstraintName("FK__Ticket__Assigned__31B762FC");

            entity.HasOne(d => d.LastModifiedByUserNavigation).WithMany(p => p.TicketLastModifiedByUserNavigations)
                .HasForeignKey(d => d.LastModifiedByUser)
                .HasConstraintName("FK__Ticket__LastModi__32AB8735");

            entity.HasOne(d => d.Project).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.ProjectId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ticket__ProjectI__339FAB6E");

            entity.HasOne(d => d.Sprint).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.SprintId)
                .HasConstraintName("FK__Ticket__SprintID__3493CFA7");
        });

        modelBuilder.Entity<TicketLog>(entity =>
        {
            entity.HasKey(e => e.TicketLogId).HasName("PK__TicketLo__FCB0524A1CBB7B1D");

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
                .HasConstraintName("FK__TicketLog__Ticke__44CA3770");

            entity.HasOne(d => d.User).WithMany(p => p.TicketLogs)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TicketLog__UserI__43D61337");
        });

        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__UserRole__8AFACE3A4A6451A7");

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
