//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace System.Databases.Exchange
{
    using System;
    using System.Collections.Generic;
    
    public partial class MsgTrackingLogsAttachment
    {
        public long ID { get; set; }
        public long MsgTrackingLogsID { get; set; }
        public string attachment_name { get; set; }
        public string attachment_location { get; set; }
        public string attachment_content_type { get; set; }
        public Nullable<long> attachment_size { get; set; }
        public Nullable<bool> attachment_is_inline { get; set; }
        public string attachment_content_id { get; set; }
        public string SHA256 { get; set; }
        public Nullable<bool> verified { get; set; }
        public Nullable<System.DateTime> verified_time { get; set; }
    
        public virtual MsgTrackingLog MsgTrackingLog { get; set; }
    }
}
