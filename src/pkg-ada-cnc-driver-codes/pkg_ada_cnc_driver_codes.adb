-- File   : pkg_ada_cnc_driver_codes.adb
-- Date   : Tue 01 Jun 2021 12:41:11 PM +08
-- Author : wruslandr@gmail.com
-- Version: Sun 30 May 2021 05:11:11 PM +08
-- ========================================================
with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Real_Time; 
use  Ada.Real_Time;  
with Ada.Strings.Unbounded;
use  Ada.Strings.Unbounded;
with Ada.Strings.Maps;

with Ada.Characters.Latin_1;
with GNAT.String_Split;

-- ========================================================
package body pkg_ada_cnc_driver_codes
-- ========================================================
--   with SPARK_Mode => on
is
   -- RENAMING STANDARD PACKAGES FOR CONVENIENCE
   package ATIO   renames Ada.Text_IO;
   package ART    renames Ada.Real_Time;
   package ASU    renames Ada.Strings.Unbounded;
   package ACL1   renames Ada.Characters.Latin_1;
   package ASM    renames Ada.Strings.Maps;
   package GSS    renames GNAT.String_Split;
   
   -- ALL REQUIRED FOR INITIALIZATION ONLY
      
   -- ALL VARIABLES DEFINITIONS
   -- type StrArray is array (Positive range <>) of ASU.Unbounded_String;
      
   ActionLineString     : GSS.Slice_Set; 
   CNC_ActionLineString : GSS.Slice_Set;
   TabAndSpace : constant String :=  (" " & ACL1.HT);
   
   -- (2) REMOVE COMMENTS IN fhandle_01 WRITE RESULTS TO fhandle_02     
   -- =====================================================
   procedure remove_gcode_comments(linestring : in String; out_fhandle_02 : in AATIO.File_Type;  linecount: Integer) is
   -- =====================================================
        
   begin
      
      -- SHOW ON SCREEN ONLY FOR COMFIRMATION
      -- ATIO.Put_Line ("ActionLineString = " & linestring);
      
      GSS.Create (S          => ActionLineString,
                  From       => linestring,
                  Separators => TabAndSpace,
                  Mode       => GSS.Multiple);
      
      
      -- LOOP THROUGH EACH FIELD FOR THE SPECIFIC LINE
      for I in 1 .. GSS.Slice_Count (ActionLineString) loop
      
         declare
            -- Pull the next substring out into a string object for easy handling.   
            the_action : constant String := GSS.Slice (ActionLineString, I);
      
         begin   
            
            if the_action = "G00" then 
               -- ATIO.Put_Line (linestring);
               ATIO.Put_Line (out_fhandle_02, linestring);
            end if;
            
            if the_action = "G01" then 
               -- ATIO.Put_Line (linestring);
               ATIO.Put_Line (out_fhandle_02, linestring);
            end if;
            
            if the_action = "G02" then 
               -- ATIO.Put_Line (linestring);
               ATIO.Put_Line (out_fhandle_02, linestring);
            end if; 
         
            if the_action = "G03" then 
               -- ATIO.Put_Line (linestring);
               ATIO.Put_Line (out_fhandle_02, linestring);
            end if; 
            
         end;
         
      end loop;
      
      
   end remove_gcode_comments;   
   
   -- (3) READ FROM fhandle_02 THEN WRITE TO fhandle_03 (BLANK ACTION FIELDS)
   -- =====================================================
   procedure create_gcode_action_file
   -- =====================================================
   is
      UBS_ActionLine : ASU.Unbounded_String;
      lineCount : Integer := 0;
      
      inp_fhandle_02    : ATIO.File_Type;
      out_fhandle_03    : ATIO.File_Type;
      
      inp_fmode_02      : ATIO.File_Mode  := ATIO.In_File;
      out_fmode_03      : ATIO.File_Mode  := ATIO.Out_File;
      
      inp_fname_02   : String := "files/ngc-driver-code-out_02.txt";
      out_fname_03   : String := "files/ngc-driver-code-out_03.txt";
      
      -- CURRENT VALUES
      ubscurr_x, ubscurr_y, ubscurr_z : ASU.Unbounded_String; 
      ubscurr_i, ubscurr_j, ubscurr_f : ASU.Unbounded_String; 
      
      -- NEXT VALUES
      ubsnext_x, ubsnext_y, ubsnext_z : ASU.Unbounded_String; 
      ubsnext_i, ubsnext_j, ubsnext_f : ASU.Unbounded_String; 
      
      -- DELTA IS THE DIFFERENCE BETWEEN CURR AND NEXT
      ubsdelta_x, ubsdelta_y, ubsdelta_z : ASU.Unbounded_String; 
      ubsdelta_i, ubsdelta_j, ubsdelta_f : ASU.Unbounded_String; 
      
   begin
      
      -- OPEN INPUT FILE 
      ATIO.Open (inp_fhandle_02, inp_fmode_02, inp_fname_02); 
  
      -- CREATE OUTPUT FILE
      ATIO.Create (out_fhandle_03, out_fmode_03, out_fname_03); 
      
      -- GO BACK TO TOP OF FILE
      -- Set line pointer back to the top of file
      ATIO.reset(inp_fhandle_02); 
      ATIO.reset(out_fhandle_03); 
      lineCount := 0;
      
      -- INITIALIZE VARIABLES
      ubscurr_x := ASU.To_Unbounded_String("0.00000E+00"); 
      ubscurr_y := ASU.To_Unbounded_String("0.00000E+00"); 
      ubscurr_z := ASU.To_Unbounded_String("0.00000E+00"); 
      ubscurr_i := ASU.To_Unbounded_String("0.00000E+00"); 
      ubscurr_j := ASU.To_Unbounded_String("0.00000E+00"); 
      ubscurr_f := ASU.To_Unbounded_String("0.00000E+00"); 
      
      ubsnext_x := ASU.To_Unbounded_String("0.00000E+00"); 
      ubsnext_y := ASU.To_Unbounded_String("0.00000E+00");
      ubsnext_z := ASU.To_Unbounded_String("0.00000E+00");
      ubsnext_i := ASU.To_Unbounded_String("0.00000E+00");
      ubsnext_j := ASU.To_Unbounded_String("0.00000E+00");
      ubsnext_f := ASU.To_Unbounded_String("0.00000E+00");
      
      -- TO BE CALCULATED AND WRITTEN INTO fhandle_04
      ubsdelta_x := ASU.To_Unbounded_String("0.00000E+00"); 
      ubsdelta_y := ASU.To_Unbounded_String("0.00000E+00");
      ubsdelta_z := ASU.To_Unbounded_String("0.00000E+00");
      ubsdelta_i := ASU.To_Unbounded_String("0.00000E+00");
      ubsdelta_j := ASU.To_Unbounded_String("0.00000E+00");
      ubsdelta_f := ASU.To_Unbounded_String("0.00000E+00");
      
      -- ========================================
      while not ATIO.End_Of_File (inp_fhandle_02) loop
         UBS_ActionLine := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle_02));
         lineCount := lineCount + 1;
         
         -- FOR VISUAL CONFIRMATION OF CORRECTNESS 
         -- ATIO.Put_Line (ASU.To_String (UBS_ActionLine));
                  
         -- PROCESS EACH LINE
         GSS.Create (S       => CNC_ActionLineString,
                  From       => ASU.To_String(UBS_ActionLine),
                  Separators => TabAndSpace,
                  Mode       => GSS.Multiple);
    
         declare
                        
            --   the_field : constant String := GSS.Slice (CNC_ActionLineString, I);
            -- GET EACH FIELD FROM THE READ LINE   
            the_lineno    : constant String := GSS.Slice (CNC_ActionLineString, 2);
            the_cncaction : constant String := GSS.Slice (CNC_ActionLineString, 3);
            next_x : constant String := GSS.Slice (CNC_ActionLineString, 4);
            next_y : constant String := GSS.Slice (CNC_ActionLineString, 5);
            next_z : constant String := GSS.Slice (CNC_ActionLineString, 6);
            next_i : constant String := GSS.Slice (CNC_ActionLineString, 7);
            next_j : constant String := GSS.Slice (CNC_ActionLineString, 8);
            next_f : constant String := GSS.Slice (CNC_ActionLineString, 9);
            
         begin  -- DECLARE   
               
            -- GET FROM READ LINE
            ubsnext_x := ASU.To_Unbounded_String (next_x);
            ubsnext_y := ASU.To_Unbounded_String (next_y);
            ubsnext_z := ASU.To_Unbounded_String (next_z);
            ubsnext_i := ASU.To_Unbounded_String (next_i);
            ubsnext_j := ASU.To_Unbounded_String (next_j);
            ubsnext_f := ASU.To_Unbounded_String (next_f);
            
            
            -- WRITE TO OUTPUT FILE (20 FIELDS)
            ATIO.Put_Line (out_fhandle_03, 
            the_lineno & " " & 
            the_cncaction & " " &
            ASU.To_String(ubscurr_x) & " " & ASU.To_String(ubsnext_x) & " " & ASU.To_String(ubsdelta_x) & " " & 
            ASU.To_String(ubscurr_y) & " " & ASU.To_String(ubsnext_y) & " " & ASU.To_String(ubsdelta_y) & " " & 
            ASU.To_String(ubscurr_z) & " " & ASU.To_String(ubsnext_z) & " " & ASU.To_String(ubsdelta_z) & " " & 
            ASU.To_String(ubscurr_i) & " " & ASU.To_String(ubsnext_i) & " " & ASU.To_String(ubsdelta_i) & " " & 
            ASU.To_String(ubscurr_j) & " " & ASU.To_String(ubsnext_j) & " " & ASU.To_String(ubsdelta_j) & " " & 
            ASU.To_String(ubscurr_f) & " " & ASU.To_String(ubsnext_f) & " " & ASU.To_String(ubsdelta_f) );            
                          
            
            -- WRITE TO SCREEN FOR VISUAL CONFIRMATION (20 FIELDS)
            -- ATIO.Put_Line ( 
            -- the_lineno & " " & 
            -- the_cncaction & " " &
            -- ASU.To_String(ubscurr_x) & " " & ASU.To_String(ubsnext_x) & " " & ASU.To_String(ubsdelta_x) & " " & 
            -- ASU.To_String(ubscurr_y) & " " & ASU.To_String(ubsnext_y) & " " & ASU.To_String(ubsdelta_y) & " " & 
            -- ASU.To_String(ubscurr_z) & " " & ASU.To_String(ubsnext_z) & " " & ASU.To_String(ubsdelta_z) & " " & 
            -- ASU.To_String(ubscurr_i) & " " & ASU.To_String(ubsnext_i) & " " & ASU.To_String(ubsdelta_i) & " " & 
            -- ASU.To_String(ubscurr_j) & " " & ASU.To_String(ubsnext_j) & " " & ASU.To_String(ubsdelta_j) & " " & 
            -- ASU.To_String(ubscurr_f) & " " & ASU.To_String(ubsnext_f) & " " & ASU.To_String(ubsdelta_f) );            
                 
                     
         end;  -- DECLARE
            
         -- SET CURRENT VALUES FOR FOR NEXT LINE 
         -- DONE OUT OF DECLARE BECAUSE NOT IN DECLARE SCOPE
         ubscurr_x := ubsnext_x;
         ubscurr_y := ubsnext_y;
         ubscurr_z := ubsnext_z;
         ubscurr_i := ubsnext_i;
         ubscurr_j := ubsnext_j;
         ubscurr_f := ubsnext_f;
     
      end loop; -- WHILE LINE LOOP
      
      ATIO.Close (inp_fhandle_02);
      ATIO.Close (out_fhandle_03);
           
   end create_gcode_action_file;

-- (4) READ FROM fhandle_03 THEN WRITE TO fhandle_04 (CALCULATE DELTAS)
-- ========================================================   
procedure calculate_gcode_delta_actions   
-- ========================================================   
is
      UBS_ActionLine : ASU.Unbounded_String;
      lineCount : Integer := 0;
      
      inp_fhandle_03    : ATIO.File_Type;
      out_fhandle_04    : ATIO.File_Type;
      
      inp_fmode_03      : ATIO.File_Mode  := ATIO.In_File;
      out_fmode_04      : ATIO.File_Mode  := ATIO.Out_File;
      
      inp_fname_03   : String := "files/ngc-driver-code-out_03.txt";
      out_fname_04   : String := "files/ngc-driver-code-out_04.txt";
      
      -- CURRENT VALUES
      ubscurr_x, ubscurr_y, ubscurr_z : ASU.Unbounded_String; 
      ubscurr_i, ubscurr_j, ubscurr_f : ASU.Unbounded_String; 
      
      -- NEXT VALUES
      ubsnext_x, ubsnext_y, ubsnext_z : ASU.Unbounded_String; 
      ubsnext_i, ubsnext_j, ubsnext_f : ASU.Unbounded_String; 
      
      -- DELTA IS THE DIFFERENCE BETWEEN CURR AND NEXT
      ubsdelta_x, ubsdelta_y, ubsdelta_z : ASU.Unbounded_String; 
      ubsdelta_i, ubsdelta_j, ubsdelta_f : ASU.Unbounded_String;       
      
begin 
      -- OPEN INPUT FILE 
      ATIO.Open (inp_fhandle_03, inp_fmode_03, inp_fname_03); 
  
      -- CREATE OUTPUT FILE
      ATIO.Create (out_fhandle_04, out_fmode_04, out_fname_04); 
      
      -- GO BACK TO TOP OF FILE
      -- Set line pointer back to the top of file
      ATIO.reset(inp_fhandle_03); 
      ATIO.reset(out_fhandle_04); 
      lineCount := 0;
      
      -- ========================================
      while not ATIO.End_Of_File (inp_fhandle_03) loop
         UBS_ActionLine := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle_03));
         lineCount := lineCount + 1;
         
         -- FOR VISUAL CONFIRMATION OF CORRECTNESS 
         -- ATIO.Put_Line (ASU.To_String (UBS_ActionLine));
                  
         -- PROCESS EACH LINE
         GSS.Create (S       => CNC_ActionLineString,
                  From       => ASU.To_String(UBS_ActionLine),
                  Separators => TabAndSpace,
                  Mode       => GSS.Multiple);
    
         declare
                      
            fltcurr_x, fltnext_x, fltdelta_x : Float;
            fltcurr_y, fltnext_y, fltdelta_y : Float;
            fltcurr_z, fltnext_z, fltdelta_z : Float;
            fltcurr_i, fltnext_i, fltdelta_i : Float;
            fltcurr_j, fltnext_j, fltdelta_j : Float;
            fltcurr_f, fltnext_f, fltdelta_f : Float;
            
            -- GET EACH FIELD FROM THE READ LINE (AS STRING)  
            the_lineno    : constant String := GSS.Slice (CNC_ActionLineString, 1);
            the_cncaction : constant String := GSS.Slice (CNC_ActionLineString, 2);
            
            strcurr_x  : constant String := GSS.Slice (CNC_ActionLineString, 3);
            strnext_x  : constant String := GSS.Slice (CNC_ActionLineString, 4);
            strdelta_x : constant String := GSS.Slice (CNC_ActionLineString, 5);
            strcurr_y  : constant String := GSS.Slice (CNC_ActionLineString, 6);
            strnext_y  : constant String := GSS.Slice (CNC_ActionLineString, 7);
            strdelta_y : constant String := GSS.Slice (CNC_ActionLineString, 8);
            strcurr_z  : constant String := GSS.Slice (CNC_ActionLineString, 9);
            strnext_z  : constant String := GSS.Slice (CNC_ActionLineString, 10);
            strdelta_z : constant String := GSS.Slice (CNC_ActionLineString, 11);
            strcurr_i  : constant String := GSS.Slice (CNC_ActionLineString, 12);
            strnext_i  : constant String := GSS.Slice (CNC_ActionLineString, 13);
            strdelta_i : constant String := GSS.Slice (CNC_ActionLineString, 14);
            strcurr_j  : constant String := GSS.Slice (CNC_ActionLineString, 15);
            strnext_j  : constant String := GSS.Slice (CNC_ActionLineString, 16);
            strdelta_j : constant String := GSS.Slice (CNC_ActionLineString, 17);
            strcurr_f  : constant String := GSS.Slice (CNC_ActionLineString, 18);
            strnext_f  : constant String := GSS.Slice (CNC_ActionLineString, 19);
            strdelta_f : constant String := GSS.Slice (CNC_ActionLineString, 20);
                
            
         begin  -- DECLARE  ========================== 
               
            -- GET FROM READ LINE AS FLOATS
            fltcurr_x  := Float'Value(strcurr_x);
            fltnext_x  := Float'Value(strnext_x);
            fltdelta_x := Float'Value(strdelta_x);
            fltdelta_x := (fltnext_x - fltcurr_x); -- Calculate delta_x
            fltcurr_y  := Float'Value(strcurr_y);
            fltnext_y  := Float'Value(strnext_y);
            fltdelta_y := Float'Value(strdelta_y);
            fltdelta_y := (fltnext_y - fltcurr_y); -- Calculate delta_y
            fltcurr_z  := Float'Value(strcurr_z);
            fltnext_z  := Float'Value(strnext_z);
            fltdelta_z := Float'Value(strdelta_z);
            fltdelta_z := (fltnext_z - fltcurr_z); -- Calculate delta_z
            fltcurr_i  := Float'Value(strcurr_i);
            fltnext_i  := Float'Value(strnext_i);
            fltdelta_i := Float'Value(strdelta_i);
            fltdelta_i := (fltnext_i - fltcurr_i); -- Calculate delta_i
            fltcurr_j  := Float'Value(strcurr_j);
            fltnext_j  := Float'Value(strnext_j);
            fltdelta_j := Float'Value(strdelta_j);
            fltdelta_j := (fltnext_j - fltcurr_j); -- Calculate delta_j
            fltcurr_f  := Float'Value(strcurr_f);
            fltnext_f  := Float'Value(strnext_f);
            fltdelta_f := Float'Value(strdelta_f);
            fltdelta_f := (fltnext_f - fltcurr_f); -- Calculate delta_f
            
            -- ================================
            
            -- WRITE TO SCREEN FOR CONFIRMATION
            -- ATIO.Put_Line ( 
            --    the_lineno & " " & the_cncaction & " " & 
           --     Float'Image(fltcurr_x) & " " & Float'Image(fltnext_x) & " " & Float'Image(fltdelta_x) & " " &
           --     Float'Image(fltcurr_y) & " " & Float'Image(fltnext_y) & " " & Float'Image(fltdelta_y) & " " &
           --     Float'Image(fltcurr_z) & " " & Float'Image(fltnext_z) & " " & Float'Image(fltdelta_z) & " " &            
           --     Float'Image(fltcurr_i) & " " & Float'Image(fltnext_i) & " " & Float'Image(fltdelta_i) & " " &
           --     Float'Image(fltcurr_j) & " " & Float'Image(fltnext_j) & " " & Float'Image(fltdelta_j) & " " &
           --     Float'Image(fltcurr_f) & " " & Float'Image(fltnext_f) & " " & Float'Image(fltdelta_f));
            
            -- WRITE TO OUTPUT FILE (20 FIELDS)
            ATIO.Put_Line (out_fhandle_04, 
                the_lineno & " " & the_cncaction & " " & 
                Float'Image(fltcurr_x) & " " & Float'Image(fltnext_x) & " " & Float'Image(fltdelta_x) & " " &
                Float'Image(fltcurr_y) & " " & Float'Image(fltnext_y) & " " & Float'Image(fltdelta_y) & " " &
                Float'Image(fltcurr_z) & " " & Float'Image(fltnext_z) & " " & Float'Image(fltdelta_z) & " " &            
                Float'Image(fltcurr_i) & " " & Float'Image(fltnext_i) & " " & Float'Image(fltdelta_i) & " " &
                Float'Image(fltcurr_j) & " " & Float'Image(fltnext_j) & " " & Float'Image(fltdelta_j) & " " &
                Float'Image(fltcurr_f) & " " & Float'Image(fltnext_f) & " " & Float'Image(fltdelta_f));
              
             -- null;
         end;  -- END DECLARE ============================
         
      end loop;  -- END WHILE LOOP     
   
   ATIO.Close (inp_fhandle_03);
   ATIO.Close (out_fhandle_04);   
   
end calculate_gcode_delta_actions;         
      
-- ========================================================
begin -- PACKAGE BEGIN
   null;
-- ========================================================
end pkg_ada_cnc_driver_codes;
-- ========================================================
