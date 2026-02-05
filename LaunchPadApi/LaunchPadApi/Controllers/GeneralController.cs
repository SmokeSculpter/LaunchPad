using LaunchPadApi.Hubs;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Mvc;

namespace LaunchPadApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GeneralController : ControllerBase
    {
        private readonly IHubContext<TestHub> _hubContext;

        public GeneralController(IHubContext<TestHub> hubContext)
        {
            _hubContext = hubContext;
        }

        public class SendMessageRequest
        {
            public string Message { get; set; }
        }

        [HttpPost("send")]
        public async Task<IActionResult> Send([FromBody] SendMessageRequest request)
        {
            await _hubContext.Clients.All.SendAsync("ReceiveMessage", request.Message);
            return Ok();
        }

    }
}
