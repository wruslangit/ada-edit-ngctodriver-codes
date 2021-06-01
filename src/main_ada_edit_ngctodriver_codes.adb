-- File: main_ada_edit_ngctodriver_codes.adb
-- Date: Tue 01 Jun 2021 12:41:11 PM +08
-- Author: WRY wruslan.ump@gmail.com
-- ========================================================
-- IMPORT STANDARD ADA PACKAGES
with Ada.Text_IO;
with Ada.Real_Time; 
use  Ada.Real_Time;
with Ada.Strings.Unbounded;

-- IMPORT USER-DEFINED ADA PACKAGES
with pkg_ada_datetime_stamp;
with pkg_ada_realtime_delays;
with pkg_ada_linestring_split;
with pkg_ada_vectorize_splitline;
with pkg_ada_cnc_driver_codes;

-- ========================================================
procedure main_ada_edit_ngctodriver_codes
-- ========================================================
--	with SPARK_Mode => on
is 
   -- RENAME STANDARD ADA PACKAGES FOR CONVENIENCE
   package ATIO    renames Ada.Text_IO;
   package ART     renames Ada.Real_Time;
   package ASU     renames Ada.Strings.Unbounded;
   
   -- RENAME USER-DEFINED ADA PACKAGES FOR CONVENIENCE
   package PADTS   renames pkg_ada_datetime_stamp;
   package PARTD   renames pkg_ada_realtime_delays;
   package PALSS   renames pkg_ada_linestring_split;
   package PAVSL   renames pkg_ada_vectorize_splitline;
   package PACDC   renames pkg_ada_cnc_driver_codes;
      
   -- PROCEDURE-WIDE VARIABLE DEFINITIONS
   startClock, finishClock   : ART.Time;  
   -- startTestClock, finishTestClock : ART.Time;
   -- deadlineDuration : ART.Time_Span;
   
   
   -- INPUT FILE 
   inp_fhandle      : ATIO.File_Type;
   inp_fmode        : ATIO.File_Mode  := ATIO.In_File;
   inp_fname        : String := "files/ngc-driver-code-inp_01.txt"; 
   inp_fform        : String := "shared=yes"; 
   inp_fOwnID       : String := "bsm-001";
   
   inp_lineCount    : Integer := 0;
   inp_UBlineStr    : ASU.Unbounded_String;
   
   -- OUTPUT FILES
   out_fhandle_01    : ATIO.File_Type;
   out_fhandle_02    : ATIO.File_Type;
   out_fhandle_03    : ATIO.File_Type;
   out_fhandle_04    : ATIO.File_Type;
      
   out_fmode_01      : ATIO.File_Mode  := ATIO.Out_File;
   out_fmode_02      : ATIO.File_Mode  := ATIO.Out_File;
      
   out_fname_01  : String := "files/ngc-driver-code-out_01.txt";
   out_fname_02  : String := "files/ngc-driver-code-out_02.txt";

        
begin  -- =================================================
   
   startClock := ART.Clock; PADTS.dtstamp;
   ATIO.Put_Line ("STARTED: main Bismillah 3 times WRY");
   PADTS.dtstamp; ATIO.Put_Line ("Running inside GNAT Studio Community");
   ATIO.New_Line;
      
   -- CODE BEGINS HERE
   -- =====================================================
   -- OPEN INPUT FILE WITH SHARING = YES 
   ATIO.Open (inp_fhandle, inp_fmode, inp_fname, inp_fform); 
  
   -- CREATE OUTPUT FILES
   ATIO.Create (out_fhandle_01, out_fmode_01, out_fname_01); 
   ATIO.Create (out_fhandle_02, out_fmode_02, out_fname_02);
    
      
   -- RESET - GO BACK TO TOP OF FILE
   ATIO.reset(inp_fhandle); -- Set line pointer back to the top of file
   inp_lineCount := 0;
    
   -- PROCESS EACH LINE
   while not ATIO.End_Of_File (inp_fhandle) loop
      inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle));
      inp_lineCount := inp_lineCount + 1;
      
      -- WRITE LINE TO SCREEN
      -- ATIO.Put_Line (ATIO.Standard_Output, ASU.To_String (inp_UBlineStr));
   
      -- WRITE LINE TO FILE AS BACKUP
      ATIO.Put_Line (out_fhandle_01, ASU.To_String (inp_UBlineStr));
      
      -- REMOVE COMMENTS IN fhandle_01 WRITE RESULTS TO fhandle_02     
      PACDC.remove_gcode_comments (ASU.To_String (inp_UBlineStr), 
                                   out_fhandle_02, 
                                   inp_lineCount); 
      
   end loop;  
   -- CLOSE ALL OPEN FILES
   ATIO.Close (out_fhandle_01);
   ATIO.Close (out_fhandle_02);
   ATIO.Close (inp_fhandle);
   
      
   -- READ FROM fhandle_02 THEN WRITE TO fhandle_03 
   -- WRITE VECTOR FROM_X TO_X FOR EACH CNC ACTION
      PACDC.create_gcode_action_file;
      
   -- WRITE TO fhandle_04 THE FOLLOWING LINE (EACH LINE = 20 FIELDS)
   -- LINENO ACTION 
   -- prevX nextX deltaX, 
   -- prevY nextY deltaY, 
   -- prevZ nextZ deltaZ, 
   -- prevI nextI deltaI,
   -- prevJ nextJ deltaJ,
   -- prevF nextF deltaF  
      
   
 
   
      
   -- CODE ENDS HERE
   -- =====================================================
   ATIO.New_Line; PADTS.dtstamp;
   ATIO.Put_line ("ENDED: main Alhamdulillah 3 times WRY. ");
   finishClock := ART.Clock;
   PADTS.dtstamp; ATIO.Put ("Current main() Total ");
   PARTD.exec_display_execution_time(startClock, finishClock); 
-- ========================================================   
end main_ada_edit_ngctodriver_codes;
-- ========================================================
