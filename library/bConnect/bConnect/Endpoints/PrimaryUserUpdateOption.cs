using System;

namespace bConnect.Endpoints
{
    /// <summary>
    /// Update options for the primary user
    /// </summary>
    [Flags]
    public enum PrimaryUserUpdateOption
    {
        /// <summary>
        /// Update the next time the primary user logs on
        /// </summary>
        UpdatePrimaryUserOnNextLogon = 0,

        /// <summary>
        /// Don't use the primary user to execute tasks
        /// </summary>
        DoNotUsePrimaryUser = 4,

        /// <summary>
        /// Always update when the primary user is logged on
        /// </summary>
        AlwaysUpdatePrimaryUser = 8,

        /// <summary>
        /// Never update when the primary user is logged on
        /// </summary>
        NeverUpdatePrimaryUser = 12
    }
}
