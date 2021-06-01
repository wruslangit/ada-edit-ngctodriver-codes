-- File   : pkg_ada_datetime_stamp.adb
-- Date   : Sun 20 Dec 2020 04:56:34 AM +08
-- Env	   : Linux HPEliteBook8470p-Ub2004-rt38 5.4.66-rt38
-- #1 SMP PREEMPT_RT Sat Sep 26 16:51:59 +08 2020 x86_64 x86_64 x86_64 GNU/Linux
-- Author: WRY wruslandr@gmail.com
-- ========================================================
-- GNAT Studio Community 2020 (20200427) hosted on x86_64-pc-linux-gnu
-- GNAT 9.3.1 targetting x86_64-linux-gnu
-- SPARK Community 2020 (20200818)

with Ada.Text_IO;
with Ada.Calendar;
with Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones;
with Ada.Real_Time; 
use  Ada.Real_Time;  -- NOTICE THIS use IMPORTANT
with Ada.Strings.Unbounded;

-- ========================================================
package body pkg_ada_datetime_stamp 
-- ========================================================
--   with SPARK_Mode => on
is
   -- RENAMING STANDARD ADA PACKAGES FOR CONVENIENCE
   package ATIO   renames Ada.Text_IO;
   package ACal   renames Ada.Calendar;
   package ACalF  renames Ada.Calendar.Formatting;
   package ART    renames Ada.Real_Time;
   package ASU    renames Ada.Strings.Unbounded;

   -- RENAMING USER_CREATED ADA PACKAGES
       
   -- ====================================================
   -- DEFINE GETTIME FUNCTION 
   -- ====================================================
    function GetTime (ClockNow : ART.Time) return String 
    is
	     Seconds  : ART.Seconds_Count;
	     Fraction : ART.Time_Span;
    begin
	     ART.Split (ClockNow, Seconds, Fraction);
        declare
          TimeFraction : constant String := Duration'Image (ART.To_Duration (Fraction));
	    begin
	       return (TimeFraction (4..TimeFraction'Last));
	    end;
    end GetTime; 
    
    -- (1) DISPLAY THE DATE-TIME STAMP
    -- ====================================================
    procedure dtstamp 
    -- ==================================================== 
    is
    begin
      -- Display the date
      ATIO.Put (ACalF.Image (ACal.Clock, True, 0));
      
      -- Display the exact time value taken at the instance
      -- the line below executes. i.e. ART.Clock execution.
      ATIO.Put (GetTime (ART.Clock) & " ");    
	
   end dtstamp;
   
   -- (2) GET THE DATE STAMP
   -- ===================================================== 
   function get_date_stamp(ClockNow : ART.Time) return ASU.Unbounded_String
   -- =====================================================  
   is
      the_date   : ASU.Unbounded_String; -- "2020-12-19 19:26:22.75";
      datestring : ASU.Unbounded_String; -- "2020-12-19";
   begin
      -- Slice characters. Take front 1 to 10 characters
      the_date   := ASU.To_Unbounded_String (ACalF.Image (ACal.Clock, True, 0));
      datestring := ASU.Unbounded_Slice (the_date, 1, 10);
         
      return (datestring);
   end get_date_stamp; 
  
   -- (3) GET THE TIME STAMP
   -- ====================================================
   function  get_time_stamp (ClockNow : in ART.Time) return ASU.Unbounded_String
   -- ====================================================  
   is
      the_date      : ASU.Unbounded_String;     -- "2020-12-19 19:26:22.75";
      time_only     : ASU.Unbounded_String;     -- "19:26:22.75";
      fraction_only : ASU.Unbounded_String;     -- "158130892108";
      timestring    : ASU.Unbounded_String;     -- "19:26:22.7558130892108";
   begin
      -- Slice and concatenate unbounded strings
      the_date  := ASU.To_Unbounded_String (ACalF.Image (ACal.Clock, True, 0));
      time_only := ASU.Unbounded_Slice (the_date, 12, 22);
      fraction_only := ASU.To_Unbounded_String (GetTime (ART.Clock));
         
      -- concatenate
      timestring := (time_only & fraction_only); 
      return (timestring);
   end get_time_stamp; 
      
   -- =====================================================
   procedure display_help_file is 
   -- =====================================================
      inp_fhandle : ATIO.File_Type; 
      inp_fmode   : ATIO.File_Mode := ATIO.In_File;
      inp_fname   : String := "src/pkg-ada-datetime-stamp/pkg_ada_datetime_stamp.hlp";
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
begin
    null;
-- ========================================================
end pkg_ada_datetime_stamp;
-- ========================================================

