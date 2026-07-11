/******************************************************************************
*
* This is the NODE part of the RING example program.
*
* Node 0 will play the role of "controller" node.
*
* It waits for a message from the host telling it:
*   a) the number of times to go around the RING, and
*   b) the length of the message to send around.
*
* It then sends a message of the desired length to node 1 and 
* "controls" how many times the message goes around the RING. 
*
* At the end, Node 0 reports back to the Host the time it took 
* the message to go around the RING.
*
*
* All the other nodes patiently wait for a message and then dutifuly
* pass it on to the next node in the RING.
*
****************************************************************************/

/*
*  Define some constants
*/
#define HOST_NID  0x8000
#define HOST_PID  1

#define INIT_TYPE  10
#define NODE_TYPE  20
#define TIME_TYPE  30
#define COUNT_TYPE 40
   
#define INIT_SIZE  4
#define TIME_SIZE  4
#define COUNT_SIZE 2
#define MAX_MSG_SIZE 16384

/*
*  iPSC System Calls used:
*/
   int copen(), status(), mynode(), mypid(), cubedim();
   long clock();
/*
*  Program variables:
*/
   int host_chan, node_chan;
   int i, count, ring_count;
   int msg_len;
   int msg_buff[8192];
   int my_node, my_pid, next_node, next_pid;
   int num_nodes;
   int rcnt, rnode, rpid;

   long start_time, ring_time;

/****************************************************************************/

main() {

/*
*  Each process identifies the node its running on and its pid:
*/
   my_node = mynode();
   my_pid  = mypid();
/*
*  Each process determines the node id & and the pid of the node following 
*  itself in the RING: 
*/
   num_nodes = 1<<cubedim();
   next_node = (my_node + 1)% num_nodes;
   next_pid  = my_pid;

   if (my_node == 0) {
/*
*     BEGIN NODE 0 CODE:
*
*     Open channels for communicating with both the next node in the 
*     RING (node 1) & the host:
*/
      node_chan = copen(my_pid);
      host_chan = copen(my_pid);
/*
*     NODE 0 MAIN LOOP:
*/
      for (;;) { 

	 recvw(host_chan, INIT_TYPE, msg_buff, INIT_SIZE, &rcnt, &rnode, &rpid);

	 ring_count = msg_buff[0];
	 msg_len    = msg_buff[1];

	 start_time = clock();

	 for(i=1;i<=ring_count;i++) {

	   sendw(node_chan, NODE_TYPE, msg_buff, msg_len, next_node, next_pid);

	   recvw(node_chan, NODE_TYPE, msg_buff, msg_len, &rcnt, &rnode, &rpid);

	   while (status(host_chan)) flick();

	   count = i;

	   send (host_chan, COUNT_TYPE, &count, COUNT_SIZE, HOST_NID, HOST_PID);

	 }

	 ring_time = clock() - start_time;

	 sendw(host_chan, TIME_TYPE, &ring_time, TIME_SIZE, HOST_NID, HOST_PID);

      }

   }
   else 
   {
/*
*     BEGIN OTHER NODES' CODE: 
*
*     All other nodes wait for a value from their left hand neighbor,
*     and pass it to their right hand neighbor.
*
*     They only have to open one channel for communication:
*/
      node_chan = copen(my_pid);

/*
*     BEGIN OTHER NODES' MAIN LOOP:
*/
      for (;;) {

        recvw(node_chan, NODE_TYPE, msg_buff, MAX_MSG_SIZE, &rcnt, &rnode, 
	      &rpid);
        sendw(node_chan, NODE_TYPE, msg_buff, rcnt, next_node, next_pid);
      }
   }
}
