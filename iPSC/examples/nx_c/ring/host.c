/******************************************************************************
*
* This is the Host code (in C) for the Ring demo.
*
* It prompts the user for:
*   a) the length of a message to send around a RING in the cube, and
*   b) the number of times the message is to go around the RING.
*
* It outputs:
*   a) a ring "count" each time the ring message goes past node 0, 
*      and 
*   b) the time it took the message to go around the ring the
*      specified number of times.
*
******************************************************************************/

/*
* Define some constants:
*/
  #define NODE_PID   1
  #define HOST_PID   1

  #define ALL_NODES -1

  #define INIT_TYPE 10

  #define INIT_MSG_SIZE 4
  #define CNT_MSG_SIZE  2
  #define TIME_MSG_SIZE 4

/*
* iPSC System Functions used:
*/
  int copen();
/*
* Program variables:
*/
  int ci,type,cnt,fr_node,fr_pid;
  int msg_len;
  int i, ring_count;
  int msg_buff[2];

  long	time_buf;
  float ring_time;

  char CARRIAGE_RETURN = 13; 
/*
******************************************************************************/

main() {

/******************************************************************************
*
* MAIN CODE: 
*/
  printf("LOADING RING INTO CUBE ...\n");
/*
* load the cube: 
*/
  load("node", ALL_NODES, NODE_PID);
/*
* Open a channel for the host-to-node-0 communications.
*/
  ci = copen(HOST_PID);
/*
* BEGIN MAIN PROGRAM LOOP:
*/
  for(;;){

     printf("************************* READY ****************************\n");
/*
*    get the number of times to go around the ring:
*/
     printf("Number of times to go around the ring (neg. value quits): ");
     scanf ("%d", &ring_count);
/*
*    If ring_count is negative break out of main loop & clean up: 
*/
     if (ring_count < 0) break;
/*
*    Include ring_count in the message to the RING:  
*/
     msg_buff[0] = ring_count;
/*
*    get the message length:  
*/
     printf("Length of Ring message in bytes (0-16384): ");
     scanf ("%d",&msg_len);
/*
*    Include msg_len in the message to the RING:  
*/
     msg_buff[1] = msg_len;
/*
*    ship the message buffer off to node 0:  
*/
     sendmsg(ci, INIT_TYPE, msg_buff, INIT_MSG_SIZE, 0, NODE_PID);
/*
*    Get the current ring count from node 0 and report to user:  
*/
     for (i=1;i<=ring_count;i++){
       recvmsg(ci, &type, msg_buff, CNT_MSG_SIZE, &cnt, &fr_node, &fr_pid);
       printf("Ring count: %d %c", msg_buff[0], CARRIAGE_RETURN);
     }
/*
*    Get the RING time from node 0 & report to user:  
*/
     recvmsg(ci, &type, &time_buf, TIME_MSG_SIZE, &cnt, &fr_node, &fr_pid);
     ring_time = (float)time_buf/1000.00;
     printf("\nRing time : %0.2f secs.\n", ring_time);
  }

/*  END OF MAIN PROGRAM LOOP.
*****************************************************************************/

/*****************************************************************************
*
* CLEAN UP TIME!
*/
  printf("CLEARING THE CUBE ...\n");
/*
* Kill RING processes in cube: 
*/
  lkill(-1,-1);
  lwaitall(-1,-1);
  printf("************************** DONE ******************************\n");
}
