namespace bConnect.Variable
{
    /// <summary>
    /// What kind of variable are you
    /// </summary>
    public enum VariableType
    {
        /// <summary>
        /// Something inexplicable
        /// </summary>
        Unknown,

        /// <summary>
        /// A plain number
        /// </summary>
        Number,

        /// <summary>
        /// Some piece of text
        /// </summary>
        String,

        /// <summary>
        /// A date (Like a timestamp, not like what you do with your girlfriend)
        /// </summary>
        Date,

        /// <summary>
        /// A checkbox that can be toggled on or off
        /// </summary>
        Checkbox,

        /// <summary>
        /// A dropdown box
        /// </summary>
        Dropdownbox,

        /// <summary>
        /// Like a dropdown box, only with multiple options to select
        /// </summary>
        DropdownListbox,

        /// <summary>
        /// A link to a specific file
        /// </summary>
        Filelink,

        /// <summary>
        /// A folder to put stuff in
        /// </summary>
        Folder,

        /// <summary>
        /// Credentials to use (be careful about securing those!)
        /// </summary>
        Password,

        /// <summary>
        /// A certificate
        /// </summary>
        Certificate
    }
}
