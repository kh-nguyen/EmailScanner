﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace System.Databases.MainDatabase
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class MainDatabaseEntities : DbContext
    {
        public MainDatabaseEntities()
            : base("name=MainDatabaseEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<ImportMail> ImportMails { get; set; }
        public virtual DbSet<MainDatabasePostProcessingQueue> MainDatabasePostProcessingQueues { get; set; }
        public virtual DbSet<Contact> Contacts { get; set; }
        public virtual DbSet<ContactsEmail> ContactsEmails { get; set; }
        public virtual DbSet<ContactsExtended> ContactsExtendeds { get; set; }
        public virtual DbSet<ContactsEmailsExtended> ContactsEmailsExtendeds { get; set; }
    }
}
