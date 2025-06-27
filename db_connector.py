import pymongo
from pymongo.errors import ConnectionFailure, OperationFailure

def get_server_credentials(host='localhost', port=27017, username='admin', password='1212', db_name='dtic', collection_name='server-info'):
    """
    Connects to MongoDB, retrieves ipsystem, usersystem, and passwordstorage,
    and returns them as a list of dictionaries.
    """
    mongo_uri = f"mongodb://{username}:{password}@{host}:{port}/"
    client = None
    credentials = []
    try:
        client = pymongo.MongoClient(mongo_uri, authSource='admin', serverSelectionTimeoutMS=5000) # Added timeout
        client.admin.command('ping') # Check connection
        db = client[db_name]
        collection = db[collection_name]
        
        # Project only the required fields to minimize data transfer
        documents = collection.find({}, {'ipsystem': 1, 'usersystem': 1, 'passwordstorage': 1, '_id': 0})

        for doc in documents:
            if 'ipsystem' in doc and 'usersystem' in doc and 'passwordstorage' in doc:
                credentials.append({
                    'ipsystem': doc['ipsystem'],
                    'usersystem': doc['usersystem'],
                    'passwordstorage': doc['passwordstorage']
                })
    except ConnectionFailure:
        # Suppress output as per request, but in real app, log this!
        pass
    except OperationFailure:
        # Suppress output
        pass
    except Exception:
        # Suppress output
        pass
    finally:
        if client:
            client.close()
    return credentials

if __name__ == '__main__':
    # This block will only run if mongo_data_fetcher.py is executed directly
    # It's here for testing purposes to see the output.
    # In the final setup, ssh_connector.py will call this function.
    # For testing, you might temporarily uncomment print(creds)
    creds = get_server_credentials()
    # print(creds)
