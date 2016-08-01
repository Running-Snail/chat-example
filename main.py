import asyncore
import collections
import logging
import socket


class RemoteClient(asyncore.dispatcher):
    def __init__(self, host, socket, address):
        asyncore.dispatcher.__init__(self, socket)
        self.host = host
        self.outbox = collections.deque()

    def say(self, message):
        self.outbox.append(message)

    def handle_read(self):
        client_message = self.recv(8192)
        self.host.broadcast(client_message)

    def handle_write(self):
        if not self.outbox:
            return
        message = self.outbox.popleft()
        if len(message) > 8192:
            raise ValueError('Message too long')
        self.send(message)

class Host(asyncore.dispatcher):
    def __init__(self, host, port):
        asyncore.dispatcher.__init__(self)
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.set_reuse_addr()
        self.bind((host, port))
        self.listen(5)
        self.remote_clients = []

    def handle_accept(self):
        socket, addr = self.accept() # For the remote client.
        print('Accepted client at %s', addr)
        self.remote_clients.append(RemoteClient(self, socket, addr))

    def handle_read(self):
        print('Received message: %s', self.read())

    def broadcast(self, message):
        print('Broadcasting message: %s', message)
        for remote_client in self.remote_clients:
            remote_client.say(message)

server = Host('localhost', 8090)
asyncore.loop()
