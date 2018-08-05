namespace bConnect.Endpoints
{
    /// <summary>
    /// What kind of endpoint is out there
    /// </summary>
    public enum EndpointType
    {
        /// <summary>
        /// The endpoint is an unknown quantity
        /// </summary>
        Unknown = 0,

        /// <summary>
        /// A windows device
        /// </summary>
        WindowsEndpoint = 1,

        /// <summary>
        /// An Android device
        /// </summary>
        AndroidEndpoint = 2,

        /// <summary>
        /// An iOS device
        /// </summary>
        iOSEndpoint = 3,

        /// <summary>
        /// A Mac device
        /// </summary>
        MacEndpoint = 4,

        /// <summary>
        /// A windows phone (RIP)
        /// </summary>
        WindowsPhoneEndpoint = 5,

        /// <summary>
        /// Some kind of network device (Such as a switch or router)
        /// </summary>
        NetworkEndpoint = 16
    }
}
