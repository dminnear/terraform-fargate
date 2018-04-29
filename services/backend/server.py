#!/usr/bin/env python3

"""
COPIED FROM https://gist.github.com/mdonkers/63e115cc0c79b4f6b8b3a6b797e485c7

Very simple HTTP server in python for logging requests
Usage::
    ./server.py [<port>]
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
import requests

class S(BaseHTTPRequestHandler):
  def do_GET(self):
    if self.path == '/health':
      self.send_response(200)
      self.end_headers()

    if self.path == "/lorem":
      response = requests.get('https://loripsum.net/api')

      self.send_response(200)
      self.send_header('Content-type', 'text/html')
      self.end_headers()
      self.wfile.write(response.text.encode('utf-8'))


def run(server_class=HTTPServer, handler_class=S, port=8080):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

if __name__ == '__main__':
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
