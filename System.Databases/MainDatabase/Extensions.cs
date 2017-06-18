using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace System.Databases.MainDatabase
{
    [MetadataType(typeof(ContactMetaData))]
    public partial class Contact
    {
        public class ContactMetaData
        {
            [AllowHtml]
            public string Notes { get; set; }
        }
    }
}
