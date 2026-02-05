using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace LaunchPadApi.Hubs
{
    public class TestHub : Hub
    {
        public async Task SendMessage(string message)
        {
            await Clients.All.SendAsync("ReceiveMessage", message);
        }
    }
}
