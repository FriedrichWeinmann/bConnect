namespace bConnect.Search
{
    /// <summary>
    /// The kind of data that was returned from search
    /// </summary>
    public enum SearchResultType
    {
        /// <summary>
        /// Something inexplicable
        /// </summary>
        Unknown = 0,

        /// <summary>
        /// A windows Endpoint
        /// </summary>
        WindowsEndpoint = 1,

        /// <summary>
        /// An android Endpoint
        /// </summary>
        AndroidEndpoint = 2,

        /// <summary>
        /// An iOS device
        /// </summary>
        iOSEndpoint = 3,

        /// <summary>
        /// A MAC device
        /// </summary>
        MacEndpoint = 4,

        /// <summary>
        /// A windows phone
        /// </summary>
        WindowsPhoneEndpoint = 5,

        /// <summary>
        /// A job running on windows
        /// </summary>
        WindowsJob = 6,

        /// <summary>
        /// A BMS Network device job
        /// </summary>
        BmsNetJob = 7,

        /// <summary>
        /// An organization unit
        /// </summary>
        OrgUnit = 8,

        /// <summary>
        /// A dynamic group
        /// </summary>
        DynamicGroup = 9,

        /// <summary>
        /// A static group
        /// </summary>
        StaticGroup = 10,

        /// <summary>
        /// An application
        /// </summary>
        Application = 11,

        /// <summary>
        /// An App
        /// </summary>
        App = 12,

        /// <summary>
        /// A network endpoint
        /// </summary>
        NetworkEndpoint = 16
    }
}
