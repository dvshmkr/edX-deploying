# /webapps/app/FlaskApp/test_env.py

import os

def print_env(environ, start_response):
    """A simple WSGI application that prints environment variables."""
    status = '200 OK'
    headers = [('Content-type', 'text/plain')]
    start_response(status, headers)
    env_str = ""
    for k, v in os.environ.items():
        env_str += f"{k}={v}\n"
    return [env_str.encode()]

if __name__ == '__main__':
    # This part is for testing if you run the file directly
    print("Environment variables when run directly:")
    for k, v in os.environ.items():
        print(f"{k}={v}")