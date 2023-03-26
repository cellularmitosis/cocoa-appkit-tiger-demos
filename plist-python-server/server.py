#!/usr/bin/python
# Written for Python 2.3.5 (Mac OS X Tiger).

from xml.sax.saxutils import escape

def to_plist(obj, fragment=False, indent=""):
    """Convert an Python object into an XML Property List."""
    # Thanks to https://code.google.com/archive/p/networkpx/wikis/PlistSpec.wiki
    # See http://www.apple.com/DTDs/PropertyList-1.0.dtd
    if fragment == False:
        xml = '<?xml version="1.0" encoding="UTF-8"?>\n'
        xml += '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n'
        xml += '<plist version="1.0">\n'
        xml += to_plist(obj, fragment=True, indent="")
        xml += "</plist>\n"
        return xml
    xml = ""
    if type(obj) == str:
        xml += indent + "<string>%s</string>\n" % escape(obj)
    elif type(obj) == int:
        xml += indent + "<integer>%s</integer>\n" % obj
    elif type(obj) == float:
        xml += indent + "<real>%s</real>\n" % obj
    elif type(obj) == bool:
        if obj == True:
            xml += indent + "<true/>\n"
        else:
            xml += indent + "<false/>\n"
    elif type(obj) == list:
        xml += indent + "<array>\n"
        for i in obj:
            xml += to_plist(i, fragment=True, indent=indent+"\t")
        xml += indent + "</array>\n"
    elif type(obj) == dict:
        xml += indent + "<dict>\n"
        for k, v in obj.iteritems():
            if type(k) != str:
                raise Exception("Dictionary key is not of type 'str': %s" % k)
            xml += indent + "\t" + "<key>%s</key>\n" % escape(k)
            xml += to_plist(v, fragment=True, indent=indent+"\t")
        xml += indent + "</dict>\n"
    else:
        raise Exception("Don't know how to handle %s" % obj)
    return xml


import BaseHTTPServer

class Handler(BaseHTTPServer.BaseHTTPRequestHandler):
    # See https://docs.python.org/release/2.3.5/lib/module-BaseHTTPServer.html
    # See https://www.programcreek.com/python/example/103649/http.server.BaseHTTPRequestHandler
    def do_GET(self):
        data = [
            {
                "title": "OpenGL Manual",
                "author": "Bob Smith"
            },
            {
                "title": "Programming in C",
                "author": "Bob Jones"
            },
        ]
        xml = to_plist(data)
        self.send_response(200)
        self.send_header("Content-type", "application/x-plist")
        self.end_headers()
        self.wfile.write(xml)
        self.wfile.close()

class Server(BaseHTTPServer.HTTPServer):
    pass


if __name__ == "__main__":
    import sys
    print "Testing to_plist:"
    for obj in [1, 3.14159, "Hello", True, False, [1,2], [1,[2,3]], {"a":1}, {"a":1,"b":2}, [{"a":1,"b":2},{"c":{"d":3}}]]:
        print
        xml = to_plist(obj)
        sys.stdout.write(xml)
    print
    print "Listening on port 8000:"
    address = ('', 8000)
    server = Server(address, Handler)
    server.serve_forever()
