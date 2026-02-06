using LaunchPadApi.Models;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Task = System.Threading.Tasks.Task;

namespace LaunchPadApi.Hubs
{
    public class DataHub : Hub
    {
        private readonly LaunchPadContext _context;

        public DataHub(LaunchPadContext context)
        {
            _context = context;
        }

        public override async Task OnConnectedAsync()
        {
            var users = new List<PadUser>();

            users = await _context.PadUsers.ToListAsync();

            await Clients.Caller.SendAsync("UserData", users);

            await base.OnConnectedAsync();
        }
    }
}
