import paramiko
from paramiko.ssh_exception import SSHException, AuthenticationException, NoValidConnectionsError
import sys
import os

# Import the function to get credentials from your MongoDB data fetcher file
# Make sure 'mongo_data_fetcher.py' is in the same directory or accessible in your Python path
from db_connector import get_server_credentials

def connect_via_ssh(hostname, username, password):
    """
    Attempts to establish an SSH connection to a given host using username/password.
    Prints "OK" on successful connection.
    """
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # Be cautious with AutoAddPolicy in production
                                                                 # For production, verify host keys manually

    try:
        client.connect(hostname, username=username, password=password, timeout=10) # Added timeout
        print("OK") # Only print "OK" on success
        return True
    except AuthenticationException:
        # Suppress specific error output as requested, but in real app, log this!
        pass
    except NoValidConnectionsError:
        # Suppress specific error output
        pass
    except SSHException:
        # Suppress specific error output
        pass
    except Exception:
        # Suppress specific error output
        pass
    finally:
        try:
            client.close()
        except Exception:
            pass # Client might not be open if connect failed

def main():
    """
    Fetches server credentials from MongoDB and attempts SSH connections.
    """
    server_credentials = get_server_credentials()

    if not server_credentials:
        # No documents found or connection failed for MongoDB, no SSH attempts.
        # Suppress message as per request.
        pass
    else:
        for server in server_credentials:
            hostname = server['ipsystem']
            username = server['usersystem']
            password = server['passwordstorage'] # WARNING: Using plain-text password for SSH!

            # Attempt SSH connection
            connect_via_ssh(hostname, username, password)

if __name__ == "__main__":
    main()
