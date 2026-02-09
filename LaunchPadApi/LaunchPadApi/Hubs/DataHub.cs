using LaunchPadApi.Models;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Task = System.Threading.Tasks.Task;
using Microsoft.AspNetCore.Authorization;
using LaunchPadApi.Views;
using LaunchPadApi.DTO;
using LaunchPadApi.Services;

namespace LaunchPadApi.Hubs
{
    [Authorize]
    public class DataHub : Hub
    {
        private readonly IDashboardService _dashboardService;

        public DataHub(IDashboardService dashboardService)
        {
            _dashboardService = dashboardService;
        }

        public async Task SendDashBoardData(int userId)
        {
            try
            {
                var dashboard = await _dashboardService.Get_Dash_View(userId);

                await Clients.Caller.SendAsync("DashBoardData", dashboard);
            }
            catch(Exception ex)
            {
                await Clients.Caller.SendAsync("DashBoardData", $"Data fetch error: {ex.Message}");
            }
        }
    }
}
