using LaunchPadApi.Hubs;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using LaunchPadApi.Models;
using Microsoft.EntityFrameworkCore;

namespace LaunchPadApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class UserController : ControllerBase
    {
        private readonly LaunchPadContext _context;

        public UserController(LaunchPadContext context)
        {
            _context = context;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get_User(int id)
        {
            var user = await _context.PadUsers.Select(user => new 
            {
                UserId = user.UserId,
                Name = user.FirstName + " " + user.LastName,
                Role = user.Role.Title,
            }).FirstOrDefaultAsync(user => user.UserId == id);

            return Ok(user);
        }
    }
}
