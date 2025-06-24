// 1. Connect to MongoDB (if not already connected) and switch to the 'dtic' database.
// If 'dtic' doesn't exist, MongoDB will create it upon the first data insertion.
use dtic;

// 2. Insert two sample documents into the 'server-info' collection.
// MongoDB will create the 'server-info' collection if it doesn't exist.
db['server-info'].insertMany([
  {
    "ip_address": "192.168.1.100",
    "environment": "produccion",
    "os": {
      "name": "Ubuntu Server 22.04 LTS",
      "os_user": "ubuntu_admin",
      "os_password": "hashed_password_1" 
    },
    "database": {
      "type": "mysql",
      "version": "8.0.26",
      "db_user": "mysql_root",
      "db_password": "hashed_db_password_1",
      "databases_list": [
        { "name": "crm_production_db", "purpose": "Customer Relationship Management" },
        { "name": "erp_main_db", "purpose": "Enterprise Resource Planning" },
        { "name": "website_analytics_db", "purpose": "Website Tracking Data" }
      ]
      // "databases_count": 3 // Can be derived from databases_list.length, optional to store
    },
    "additional_notes": "Main production database server for critical applications."
  },
  {
    "ip_address": "192.168.1.101",
    "environment": "desarrollo",
    "os": {
      "name": "CentOS Stream 9",
      "os_user": "dev_user",
      "os_password": "hashed_password_2" // Remember to hash/encrypt in real applications!
    },
    "database": {
      "type": "postgresql",
      "version": "14.5",
      "db_user": "postgres_dev",
      "db_password": "hashed_db_password_2", // Remember to hash/encrypt in real applications!
      "databases_list": [
        { "name": "dev_project_x", "purpose": "Development environment for Project X" },
        { "name": "staging_ecommerce", "purpose": "Staging environment for e-commerce" }
      ]
      // "databases_count": 2 // Can be derived from databases_list.length, optional to store
    },
    "additional_notes": "Development server, used for testing new features."
  }
]);

// 3. (Optional) Verify the insertion
// This command will find all documents in the 'server-info' collection and print them.
db['server-info'].find().pretty();