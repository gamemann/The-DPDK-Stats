#ifndef DPDK_STATS_HEADER
#define DPDK_STATS_HEADER

/* Helpful defines */
#ifndef htons
#define htons(o) cpu_to_be16(o)
#endif

#define ETH_P_IP 0x0800
#define ETH_P_8021Q	0x8100
#define PROTOCOL_UDP 0x11
#define PROTOCOL_TCP 0x06

//#define DEBUG

#endif