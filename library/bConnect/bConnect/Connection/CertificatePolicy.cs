using System.Net;
using System.Security.Cryptography.X509Certificates;

namespace bConnect.Connection
{
    /// <summary>
    /// Custom Certificate Policy, in order to support overriding Endpoint validation
    /// </summary>
    public class CertificatePolicy : ICertificatePolicy
    {
        /// <summary>
        /// Always returns true, in order to cheat certificate validation.
        /// </summary>
        /// <param name="sPoint"></param>
        /// <param name="cert"></param>
        /// <param name="wRequest"></param>
        /// <param name="certProb"></param>
        /// <returns></returns>
        public bool CheckValidationResult(ServicePoint sPoint, X509Certificate cert, WebRequest wRequest, int certProb)
        {
            return true;
        }
    }
}
