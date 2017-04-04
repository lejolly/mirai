#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <errno.h>
#include <string.h>

#define INET_ADDR(o1,o2,o3,o4) (htonl((o1 << 24) | (o2 << 16) | (o3 << 8) | (o4 << 0)))

int main(int argc, char **args)
{
    char hello[] = "hello";
    char world[] = "has been compromised";
    uint8_t length1 = 5;
    uint8_t length2 = 21;
    if (argc > 1) {
        printf("args[1]: %s\n", args[1]);
        length1 = strlen(args[1]);
        printf("length of args[1]: %d\n", length1);
    }

    struct sockaddr_in addr;
    int fd;
    if ((fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        printf("failed to call socket()\n");
        exit(0);
    }

    uint32_t serverIp = INET_ADDR(10, 0, 2, 15);
    uint16_t serverPort = 48102;

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = serverIp;
    addr.sin_port = htons(serverPort);

    int len=20;
    char buffer[len];
    inet_ntop(AF_INET, &(addr.sin_addr.s_addr), buffer, len);
    printf("sending to ip: %s:%d\n", buffer, serverPort);

    if (connect(fd, (struct sockaddr *)&addr, sizeof (struct sockaddr_in)) == -1) {
        printf("Error when connecting! %s\n", strerror(errno));
        close(fd);
        exit(0);
    }

    uint8_t zero = 0;
    uint32_t ip = INET_ADDR(0, 0, 0, 0);
    uint16_t port = htons(0);
    uint8_t length = 0;

    send(fd, &zero, sizeof(uint8_t), MSG_NOSIGNAL);
    send(fd, &ip, sizeof (uint32_t), MSG_NOSIGNAL);
    send(fd, &port, sizeof(uint16_t), MSG_NOSIGNAL);
    send(fd, &length1, sizeof(uint8_t), MSG_NOSIGNAL);
    if (argc > 1) {
        send(fd, args[1], length1, MSG_NOSIGNAL);
    } else {
        send(fd, &hello, length1, MSG_NOSIGNAL);
    }
    send(fd, &length2, sizeof(uint8_t), MSG_NOSIGNAL);
    send(fd, &world, length2, MSG_NOSIGNAL);

    close(fd);
    exit(0);
}
