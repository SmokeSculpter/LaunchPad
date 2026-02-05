using LaunchPadApi.Hubs;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Mvc;
using LaunchPadApi.Models;
using Microsoft.EntityFrameworkCore;

namespace LaunchPadApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GeneralController : ControllerBase
    {
        private readonly IHubContext<TestHub> _hubContext;

        private readonly LaunchPadContext _context;

        public GeneralController(IHubContext<TestHub> hubContext, LaunchPadContext context)
        {
            _hubContext = hubContext;
            _context = context;
        }


        [HttpPost("sendUsers")]
        public async Task<IActionResult> Send()
        {
            var users = await _context.PadUsers.Select(user => new
            {
                Name = user.FirstName + " " + user.LastName
            }).ToListAsync();

            await _hubContext.Clients.All.SendAsync("UpdateUsers", users);
            return Ok();
        }

    }
}
