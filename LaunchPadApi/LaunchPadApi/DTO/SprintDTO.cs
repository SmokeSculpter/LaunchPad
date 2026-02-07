namespace LaunchPadApi.DTO
{
    public class SprintDTO
    {
        public required int SprintId { get; set; }

        public string Goal { get; set; } = string.Empty;

        public required string SprintStatus { get; set; } = "Planning";

        public required DateOnly StartDate {  get; set; }

        public DateOnly? EndDate { get; set; } = null;

        public required int EarnedPoints { get; set; }

        public required int TotalPoints { get; set; }

        public required int ProjectId { get; set; }
    }
}
