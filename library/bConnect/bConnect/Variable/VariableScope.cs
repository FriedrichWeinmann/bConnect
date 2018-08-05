namespace bConnect.Variable
{
    /// <summary>
    /// The scope a variable applies to
    /// </summary>
    public enum VariableScope
    {
        /// <summary>
        /// An individual device
        /// </summary>
        Device,

        /// <summary>
        /// A mobile device in particular
        /// </summary>
        MobileDevice,

        /// <summary>
        /// An organization unit
        /// </summary>
        OrgUnit,

        /// <summary>
        /// A job
        /// </summary>
        Job,

        /// <summary>
        /// To some software package
        /// </summary>
        Software,

        /// <summary>
        /// To a given hardware profile
        /// </summary>
        HardwareProfile
    }
}
