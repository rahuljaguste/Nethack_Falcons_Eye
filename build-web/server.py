#!/usr/bin/env python3
"""
HTTP server with headers required for Emscripten/WebAssembly apps.
Includes COOP/COEP headers for SharedArrayBuffer support.
"""

import http.server
import socketserver
import os

PORT = 8081

# Change to the script's directory so files are served from build-web
os.chdir(os.path.dirname(os.path.abspath(__file__)))

class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Required for SharedArrayBuffer (used by Emscripten threading/Asyncify)
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        # Allow CORS for local development
        self.send_header('Access-Control-Allow-Origin', '*')
        # Proper MIME types
        self.send_header('Cache-Control', 'no-cache')
        super().end_headers()

    def guess_type(self, path):
        # Ensure correct MIME types for WebAssembly files
        if path.endswith('.wasm'):
            return 'application/wasm'
        if path.endswith('.js'):
            return 'application/javascript'
        return super().guess_type(path)

if __name__ == '__main__':
    with socketserver.TCPServer(("", PORT), CORSRequestHandler) as httpd:
        print(f"Serving at http://localhost:{PORT}")
        print("Required headers for Emscripten enabled (COOP/COEP)")
        print("Press Ctrl+C to stop")
        httpd.serve_forever()
