namespace bConnect.Search
{
    /// <summary>
    /// What to scan by
    /// </summary>
    public enum InventoryScanType
    {
        /// <summary>
        /// Unknown type
        /// </summary>
        Unknown,

        /// <summary>
        /// Some custom type
        /// </summary>
        Custom,

        /// <summary>
        /// Scan using WMI
        /// </summary>
        WMI,

        /// <summary>
        /// Hardware-based scan
        /// </summary>
        Hardware
    }
}
