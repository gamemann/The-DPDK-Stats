#ifndef CMDLINE_HEADER
#define CMDLINE_HEADER

#include <linux/types.h>

struct cmdline
{
    __u16 queues;
    unsigned int promisc : 1;
    unsigned int tx : 1;
    unsigned int tcp : 1;
};

int parsecmdline(struct cmdline *cmd, int argc, char **argv);
#endif