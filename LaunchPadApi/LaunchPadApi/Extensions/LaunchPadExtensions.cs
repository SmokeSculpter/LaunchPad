using LaunchPadApi.Services;

namespace LaunchPadApi.Extensions
{
    public static class LaunchPadExtensions
    {
        public static IServiceCollection InjectDbDependenices(this IServiceCollection services)
        {
            services.AddScoped<IDashboardService, DashboardService>();
            services.AddScoped<ITicketServices, TicketServices>();

            return services;
        }
    }
}
