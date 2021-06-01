-- File   : pkg_ada_realtime_delays.adb
-- Date   : Sun 07 Mar 2021 06:00:42 PM +08
-- Author : wruslandr@gmail.com
-- Version: 1.0 Sun 07 Mar 2021 06:00:42 PM +08
-- ========================================================
with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Real_Time; 
use  Ada.Real_Time;  
with Ada.Strings.Unbounded;

-- ========================================================
package body pkg_ada_realtime_delays 
-- ========================================================
--   with SPARK_Mode => on
is
   -- RENAMING STANDARD PACKAGES FOR CONVENIENCE
   package ATIO   renames Ada.Text_IO;
   package ART    renames Ada.Real_Time;
   package ASU    renames Ada.Strings.Unbounded;
  
   
    -- ALL REQUIRED FOR INITIALIZATION ONLY
     sec_RTInterval  : ART.Time_Span  := ART.Seconds(1);
    msec_RTInterval  : ART.Time_Span  := ART.Milliseconds(1);
    usec_RTInterval  : ART.Time_Span  := ART.Microseconds(1);
    nsec_RTInterval  : ART.Time_Span  := ART.Nanoseconds (1);
    RTNext	           : ART.Time       := ART.Clock;

   -- =====================================================
   procedure exec_delay_time (interval : in ART.Time_Span) 
   -- =====================================================  
   is
   begin
      delay until (ART.Clock + interval);
   end exec_delay_time; 

   -- =====================================================
   procedure exec_delay_sec (sec : in Positive)
   -- =====================================================  
   is
   begin
       delay until ART.Clock + ART.Seconds(sec);
   end exec_delay_sec;   
   
   -- =====================================================
   procedure exec_delay_msec (msec : in Positive) 
   -- =====================================================  
   is
   begin
       delay until ART.Clock + ART.Milliseconds(msec);
   end exec_delay_msec; 
 
   -- =====================================================
   procedure exec_delay_usec (usec : in Positive)
   -- =====================================================  
   is
   begin
       delay until ART.Clock + ART.Microseconds(usec);
   end exec_delay_usec;   
    
   -- (5) ONCE-OFF DELAY NSEC
   -- =====================================================
   procedure exec_delay_nsec (nsec : in Positive)
   -- =====================================================
   is
   begin
       delay until ART.Clock + ART.Nanoseconds(nsec);
   end exec_delay_nsec; 
   
   -- (6) PROCEDURE CHECK EXECUTION OVERRUN UNDERRUN
   -- =====================================================   
   procedure exec_checktiming_overrun_underrun (startClock, finishClock : in AART.Time; deadlineDuration : in AART.Time_Span) 
   -- ===================================================
   is
         overrunTime : AART.Time_Span;
   begin
      
      if is_timing_overrun (startClock, finishClock, deadlineDuration) then
      -- Overrun True  
         ATIO.Put_Line ("Raise Execution Time Overrun +++");      
         ATIO.Put("   Actual execution duration (sec) = "); 
         ATIO.Put_Line (Duration'Image(To_Duration (finishClock - startClock))); 
         ATIO.Put("   Deadline duration setting (sec) = "); 
         ATIO.Put_Line (Duration'Image(To_Duration (deadlineDuration))); 
         ATIO.Put("   Resulting time overrun by (sec) = ");
         overrunTime := (finishClock - startClock) - (deadlineDuration);
         ATIO.Put_Line (Duration'Image (To_Duration (overrunTime)));
         ATIO.New_Line;
      else 
      -- Overrun False 
         ATIO.Put_Line ("Raise Execution Time Underrun ---");      
         ATIO.Put("   Actual execution duration  (sec) = "); 
         ATIO.Put_Line (Duration'Image(To_Duration (finishClock - startClock))); 
         ATIO.Put("   Deadline duration setting  (sec) = "); 
         ATIO.Put_Line (Duration'Image(To_Duration (deadlineDuration))); 
         ATIO.Put("   Resulting time underrun by (sec) = ");
         overrunTime := (finishClock - startClock) - (deadlineDuration);
         ATIO.Put_Line (Duration'Image (To_Duration (overrunTime)));
         ATIO.New_Line;
      end if;
   end exec_checktiming_overrun_underrun;

   -- (7) FUNCTION EXECUTION OVERRUN
   -- =====================================================  
   function is_timing_overrun (startClock, finishClock : in AART.Time; deadlineDuration : in AART.Time_Span) return Boolean 
   -- =====================================================
   is
   begin
      if (finishClock - startClock) > deadlineDuration then
         return True; 
      else 
         return False; 
      end if;
   end is_timing_overrun ;   
   
   -- ========================================================
   function get_execution_time_duration (startClock, finishClock : in AART.Time) return AART.Time_Span
   -- ========================================================
   is
        executionTime : AART.Time_Span;
   begin
        executionTime := (finishClock - startClock);
        return (executionTime); 
   end get_execution_time_duration;
   
   -- ========================================================
   procedure exec_display_execution_time (startClock, finishClock : in AART.Time)
   -- ========================================================
   is
        executionTime : AART.Time_Span;
   begin
      executionTime := (finishClock - startClock);
        ATIO.Put ("Execution time: ");
        ATIO.Put (Duration'Image (To_Duration (executionTime)));
        ATIO.Put_Line (" seconds.");
   end exec_display_execution_time; 
   
   -- =====================================================
   procedure display_help_file is 
   -- =====================================================
      inp_fhandle : ATIO.File_Type; 
      inp_fmode   : ATIO.File_Mode := ATIO.In_File;
      inp_fname   : String := "src/pkg-ada-realtime-delays/pkg_ada_realtime_delays.hlp";
      inp_UBlineStr : ASU.Unbounded_String;
   
   begin
      ATIO.Open (inp_fhandle, inp_fmode, inp_fname); 
      
      -- Traverse file line by line and display line to screen
      while not ATIO.End_Of_File (inp_fhandle) loop
         inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle));
         ATIO.Put_Line (ATIO.Standard_Output, ASU.To_String (inp_UBlineStr)); 
      end loop;   
      
      ATIO.Close(inp_fhandle);
   end display_help_file;
      
   -- =====================================================
   procedure about_package is 
   -- =====================================================  
   begin
      -- Read from external text file and display      
      display_help_file;
      
   end about_package; 
   
-- ========================================================
begin -- PACKAGE BEGIN
    null;
-- ========================================================
end pkg_ada_realtime_delays;
-- ========================================================
