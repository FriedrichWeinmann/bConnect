using System;

namespace bConnect.Endpoints
{
    /// <summary>
    /// How to do user related jobs
    /// </summary>
    [Flags]
    public enum UserJobOptions
    {
        /// <summary>
        /// Waiting is for those without resolve
        /// </summary>
        AlwaysExecuteUserJobs = 0,

        /// <summary>
        /// Let's not do this
        /// </summary>
        NeverExecuteUserRelatedJobs = 16,

        /// <summary>
        /// Only the boss can do this
        /// </summary>
        ExecuteUserRelatedJobsPrimaryUser = 48
    }
}
