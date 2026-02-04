# LaunchPad
A modern project management application built for Agile/Scrum teams.

**Latest Development Log:** [Log-3 (February 4th)](https://github.com/SmokeSculpter/LaunchPad/tree/main/Logs/Log-3)

## Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Planned Features](#planned-features)
  - [Project Structure](#project-structure)
  - [Workflow Management](#workflow-management)
  - [Ticket Management](#ticket-management)
  - [User Experience](#user-experience)
- [Development Logs](#development-logs)
- [Status](#status)

## Overview
LaunchPad is a full-stack project management tool designed to streamline Agile workflows. It features a Scrum board for high-level ticket tracking and Kanban boards for detailed task management within each ticket.

## Tech Stack
- **Frontend:** Next.js
- **Backend:** ASP.NET + Entity Framework
- **Database:** SQL Server
- **Authentication:** Clerk
- **Real-Time:** WebSocket/SignalR

## Planned Features

### Project Structure
- Multiple projects per organization
- Role-based permissions (Software Dev, QA, Project Manager, etc.)
- Project settings and configuration

### Workflow Management
- **Scrum Board** - High-level view of tickets across sprints
- Status tracking: Backlog, To-Do, In-Progress, In-Review, Done
- Sprint planning and management

### Ticket Management
- Rich text descriptions with Markdown support
- Priority levels (Low, Medium, High)
- User assignment with history tracking
- Threaded comment discussions
- Audit logging for status changes

### User Experience
- Drag-and-drop interface with optimistic UI updates
- Global search with keyboard shortcuts
- Real-time collaboration
- Responsive design for all devices
- Loading states and meaningful error handling

## Development Logs
- [Log-1](https://github.com/SmokeSculpter/LaunchPad/tree/main/Logs/Log-1) - Initial project setup
- [Log-2](https://github.com/SmokeSculpter/LaunchPad/tree/main/Logs/Log-2) - Feature planning and initial ERD
- [Log-3](https://github.com/SmokeSculpter/LaunchPad/tree/main/Logs/Log-3) - Database schema finalization and SQL script

## Status
Currently in early development - database schema complete, implementation in progress.
