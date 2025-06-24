# db_connector.py
import pymongo

class MongoDBConnector:
    def __init__(self, host='localhost', port=27017, db_name='dtic', collection_name='servers'):
        self.host = host
        self.port = port
        self.db_name = db_name
        self.collection_name = collection_name
        self.client = None
        self.db = None
        self.collection = None

    def connect(self):
        """Establishes a connection to MongoDB."""
        try:
            self.client = pymongo.MongoClient(f"mongodb://{self.host}:{self.port}/")
            self.db = self.client[self.db_name]
            self.collection = self.db[self.collection_name]
            print(f"Connected to MongoDB at {self.host}:{self.port}, DB: {self.db_name}")
            return True
        except Exception as e:
            print(f"Error connecting to MongoDB: {e}")
            self.client = None
            return False

    def disconnect(self):
        """Closes the MongoDB connection."""
        if self.client:
            self.client.close()
            print("Disconnected from MongoDB.")

    def get_server_configs(self):
        """Retrieves all server configuration documents."""
        if not self.collection:
            print("MongoDB not connected. Call connect() first.")
            return []
        try:
            return list(self.collection.find({}))
        except Exception as e:
            print(f"Error fetching server configurations: {e}")
            return []

# Example usage (for testing this module directly)
if __name__ == "__main__":
    db_conn = MongoDBConnector()
    if db_conn.connect():
        servers = db_conn.get_server_configs()
        for server in servers:
            print(server)
    db_conn.disconnect()