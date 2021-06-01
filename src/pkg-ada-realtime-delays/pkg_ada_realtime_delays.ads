-- File   : pkg_ada_realtime_delays.ads
-- Date   : Sun 07 Mar 2021 06:00:42 PM +08
-- Author : wruslandr@gmail.com
-- Version: 1.0 Sun 07 Mar 2021 06:00:42 PM +08
-- ========================================================
with Ada.Real_Time;         
use  Ada.Real_Time;

-- ======================================================== 
package pkg_ada_realtime_delays 
-- ========================================================
    with SPARK_Mode => on
is
   
   package AART renames Ada.Real_Time;
   
   -- interval (seconds with decimal fractions for Time_Span)
   -- Positive (integer 1 and above)
   -- Natural  (integer zero and Positive)
   -- Integer  (positive and negative) 
   
   procedure exec_delay_time (interval : in AART.Time_Span); 
   procedure exec_delay_sec  (sec  : in Positive);        
   procedure exec_delay_msec (msec : in Positive);
   procedure exec_delay_usec (usec : in Positive);
   procedure exec_delay_nsec (nsec : in Positive);
   
   -- EXAMPLE USAGE OF VARIABLES
   -- startClock  := AART.Clock;
   -- finishClock := AART.Clock;
   -- deadlineDuration := 3.5;     meaning 3.5 seconds of Time_Span.
   
   procedure exec_checktiming_overrun_underrun (startClock, finishClock : in AART.Time; 
                                                deadlineDuration : in AART.Time_Span);
                                                
   procedure exec_display_execution_time (startClock, finishClock : in AART.Time);
   
   function is_timing_overrun (startClock, finishClock : in AART.Time; 
                               deadlineDuration : in AART.Time_Span) 
                               return Boolean;
                               
   function  get_execution_time_duration (startClock, finishClock : in AART.Time) 
                               return AART.Time_Span;
   procedure about_package;
-- ======================================================== 
end pkg_ada_realtime_delays;
-- ========================================================

