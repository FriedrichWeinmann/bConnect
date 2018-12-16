using System;

namespace bConnect.Endpoints
{
    /// <summary>
    /// The options an endpoint may have
    /// </summary>
    [Flags]
    public enum EndpointOptions
    {
        /// <summary>
        /// Allows installing an OS on it
        /// </summary>
        AllowOSInstall = 1,

        /// <summary>
        /// Automatic installation of applications
        /// </summary>
        AllowAutoInstall = 2,

        /// <summary>
        /// Update the next time the primary user logs on
        /// </summary>
        UpdatePrimaryUserOnNextLogon = 0,

        /// <summary>
        /// Don't use the primary user
        /// </summary>
        DoNotUsePrimaryUser = 4,

        /// <summary>
        /// Always update when the primary user is logged on
        /// </summary>
        AlwaysUpdatePrimaryUser = 8,

        /// <summary>
        /// Never update while the porimary user is logged on
        /// </summary>
        NeverUpdatePrimaryUser = 12,

        /// <summary>
        /// Waiting is for those without resolve
        /// </summary>
        AlwaysExecuteUserJobs = 0,

        /// <summary>
        /// Don't run code that is user specific
        /// </summary>
        NeverExecuteUserRelatedJobs = 16,

        /// <summary>
        /// Execute user related tasks only when the primary user is logged on
        /// </summary>
        ExecuteUserRelatedJobsPrimaryUser = 48,

        /// <summary>
        /// Automatically track usage of something
        /// </summary>
        AutomaticUsageTracking = 256,

        /// <summary>
        /// Manage the energy options?
        /// </summary>
        EnergyManagement = 512,
    }
}
