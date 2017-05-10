#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    int socketfd = 0;
    struct sockaddr_in address;

    socketfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&address, '0', sizeof(address));

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl(INADDR_ANY);
    address.sin_port = htons(0);

    socklen_t address_size = sizeof(address);

    bind(socketfd, (struct sockaddr*)&address, sizeof(address));

    getsockname(socketfd, (struct sockaddr*)&address, &address_size);
    printf("%d\n", ntohs(address.sin_port));

}
