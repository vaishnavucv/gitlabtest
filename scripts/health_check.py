import http.client
import sys
import time

def check_health(ip, port, path="/", retries=5, delay=5):
    print(f"Starting health check for {ip}:{port}{path}...")
    for i in range(retries):
        try:
            conn = http.client.HTTPConnection(ip, port, timeout=10)
            conn.request("GET", path)
            response = conn.getresponse()
            if response.status == 200:
                print(f"Health check passed! Status: {response.status}")
                return True
            else:
                print(f"Health check failed. Status: {response.status}")
        except Exception as e:
            print(f"Attempt {i+1} failed: {e}")
        
        if i < retries - 1:
            print(f"Retrying in {delay} seconds...")
            time.sleep(delay)
    
    return False

if __name__ == "__main__":
    # In a real scenario, you'd pass these as arguments
    target_ip = "10.10.0.2"
    target_port = 80
    
    if check_health(target_ip, target_port):
        print("Application is up and running.")
        sys.exit(0)
    else:
        print("Application failed to start correctly.")
        sys.exit(1)
