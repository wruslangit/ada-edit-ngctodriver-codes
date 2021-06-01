-- File   : pkg_ada_vectorize_splitline.adb
-- Date   : Sun 30 May 2021 05:11:11 PM +08
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
-- use  Ada.Characters;
-- use  GNAT;

-- ========================================================
package body pkg_ada_vectorize_splitline 
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
   gbl_flt_feedrate_20 : Float := 0.0; 
   gbl_flt_feedrate_21 : Float := 0.0;
   gbl_flt_scaling_x   : Float := 0.0; 
   gbl_flt_scaling_y   : Float := 0.0; 
   gbl_flt_scaling_z   : Float := 0.0; 
   gbl_flt_scaling_i   : Float := 0.0; 
   gbl_flt_scaling_j   : Float := 0.0; 
   gbl_flt_offset_x    : Float := 0.0; 
   gbl_flt_offset_y    : Float := 0.0; 
   gbl_flt_offset_z    : Float := 0.0; 
   
   -- vflt_feedrate_20, vflt_feedrate_21, vflt_scaling_z, vflt_scaling_xy : Float; 
   -- vflt_offset_x,    vflt_offset_y,    vflt_offset_z : Float; 
   
   vubs_action : ASU.Unbounded_String; 
   vfltnext_x, vfltnext_y, vfltnext_z, vfltnext_i, vfltnext_j, vfltnext_f : Float; 
   
      
   -- =====================================================
   procedure vectorize_eachline (linestring : String; 
                                 out_fhandle_02, out_fhandle_03, out_fhandle_04 : ATIO.File_Type; 
                                 linecount : Integer) is 
   -- =====================================================
      -- Define substrings array to be populated by the actual substring elements   
      -- separated by TabAndSpace
      substrings : GSS.Slice_Set;
      TabAndSpace : constant String :=  (" " & ACL1.HT);
      
      -- ubs_action : ASU.Unbounded_String; 
      
      
    begin 
    
      -- WRITE TO FILE AND WRITE TO SCREEN
      -- Identify and write each line read in steps of 10 (so that 10 count intervals can be used for others)
      ATIO.Put_Line (out_fhandle_02, Integer'Image(10*linecount) & " Splitting '" & linestring & "' at whitespace.");
      ATIO.Put_Line (Integer'Image(10*linecount) & " Splitting '" & linestring & "' at whitespace.");
      
      -- CREATE ARRAY OF SUBSTRINGS
      -- Create the split, using Multiple mode to treat strings of multiple
      -- whitespace characters as a single separator. This populates the subsrings array object.
      GSS.Create (S          => substrings,
                  From       => linestring,
                  Separators => TabAndSpace,
                  Mode       => GSS.Multiple);
      
      -- WRITE TO FILE AND WRITE TO SCREEN
      ATIO.Put_Line (out_fhandle_02, Integer'Image(10*linecount) & " captured total count =" & GSS.Slice_Number'Image (GSS.Slice_Count (substrings)) & " substrings:");      
      ATIO.Put_Line (Integer'Image(10*linecount) & " captured total count =" & GSS.Slice_Number'Image (GSS.Slice_Count (substrings)) & " substrings:");
     
      
      
      -- =================================================================
      --  LOOP THROUGH substrings ARRAY.
      --  Report results, starting with the count of substrings created.
      for I in 1 .. GSS.Slice_Count (substrings) loop
      
         declare
            -- Pull the next substring out into a string object for easy handling.   
            the_token : constant String := GSS.Slice (substrings, I);
            
            ubs_feedrate_20, ubs_feedrate_21, ubs_scaling_z, ubs_scaling_xy : ASU.Unbounded_String; 
            ubs_offset_x,    ubs_offset_y,    ubs_offset_z : ASU.Unbounded_String; 
            ubs_token, ubs_action, ubsnext_x, ubsnext_y, ubsnext_z, ubsnext_i, ubsnext_j, ubsnext_f : ASU.Unbounded_String; 
                      
                        
            flt_feedrate_20, flt_feedrate_21, flt_scaling_z, flt_scaling_xy : Float; 
            flt_offset_x,    flt_offset_y,    flt_offset_z : Float; 
            fltnext_x, fltnext_y, fltnext_z, fltnext_i, fltnext_j, fltnext_f : Float; 
                        
            endNumberX, endNumberY, endNumberZ, endNumberI, endNumberJ : Natural; 
            
         begin
            -- WRITE TO FILE AND WRITE TO SCREEN
            -- Output the individual substrings (tokens), and its length.
            ATIO.Put_Line (out_fhandle_02, GSS.Slice_Number'Image (I) & " -> " & the_token );  
            ATIO.Put_Line (GSS.Slice_Number'Image (I) & " -> " & the_token );
            
            -- RESET VALUES 
            ubs_token := ASU.To_Unbounded_String ("none");  ubs_action := ASU.To_Unbounded_String ("none");
            ubsnext_x := ASU.To_Unbounded_String ("none");  ubsnext_y  := ASU.To_Unbounded_String ("none");
            ubsnext_z := ASU.To_Unbounded_String ("none");  ubsnext_i  := ASU.To_Unbounded_String ("none");
            ubsnext_j := ASU.To_Unbounded_String ("none");  ubsnext_f  := ASU.To_Unbounded_String ("none");
            
            ubs_feedrate_20 := ASU.To_Unbounded_String ("none"); ubs_feedrate_21 := ASU.To_Unbounded_String ("none");
            ubs_scaling_xy  := ASU.To_Unbounded_String ("none"); ubs_scaling_z   := ASU.To_Unbounded_String ("none");
            ubs_offset_x    := ASU.To_Unbounded_String ("none"); ubs_offset_y    := ASU.To_Unbounded_String ("none");
            ubs_offset_z    := ASU.To_Unbounded_String ("none"); 
                        
            flt_feedrate_20 := 0.0; flt_feedrate_21 := 0.0; flt_scaling_z := 0.0; flt_scaling_xy := 0.0; 
            flt_offset_x    := 0.0; flt_offset_y    := 0.0; flt_offset_z  := 0.0; 
            fltnext_x       := 0.0; fltnext_y       := 0.0; fltnext_z     := 0.0; 
            fltnext_i       := 0.0; fltnext_j       := 0.0; fltnext_f     := 0.0; 
            
            endNumberX       := 0; -- Natural (0 and Positive) 
            endNumberY       := 0; -- Natural (0 and Positive) 
            endNumberZ       := 0; -- Natural (0 and Positive) 
            endNumberI       := 0; -- Natural (0 and Positive) 
            endNumberJ       := 0; -- Natural (0 and Positive) 
            
            -- THE ACTUAL STRING TOKEN = the_token FROM THE LOOP
            ubs_token := ASU.To_Unbounded_String (the_token);
            
            -- (1) ACTION CODES ===================================================
            -- FOR first character % = Control
            if (ubs_token = "%") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
                             
               ATIO.Put_Line (Integer'Image(10*linecount) & " %" );               
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " %" ); 
               
            end if;
            
            -- FOR first 2 chars M2 = Control
            if (ubs_token = "M2") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " M2" );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " M2" ); 
            end if;
            
            -- FOR first 2 chars M3 = Control
            if (ubs_token = "M3") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " M3" );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " M3" ); 
            end if;
            
            -- FOR first 2 chars M5 = Control
            if (ubs_token = "M5") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " M5" ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " M5" ); 
            end if;
            
            -- FOR first 3 chars G21 = All units in mm
            if (ubs_token = "G21") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " G21 All units in mm" ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " G21 All units in mm" ); 
            end if;
            
            -- (2) AXIS OFFSET, SCALING, FEEDRATE CODES ==================================
            -- X-axis Offset
            if (ubs_token = "#6") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
                            
               ubs_offset_x := ASU.To_Unbounded_String (GSS.Slice (substrings, 3));
               ATIO.Put_Line (Integer'Image(10*linecount) & " #6 ubs_offset_x = " & ASU.To_String (ubs_offset_x) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " #6 ubs_offset_x = " & ASU.To_String (ubs_offset_x) ); 
            
               -- CONVERT STRING TO REAL AND INTEGER NUMBERS
               -- Image(X)        -- convert the integer X to a string
               -- Value(X)        -- convert the string X to an integer
               
               flt_offset_x := Float'Value(ASU.To_String(ubs_offset_x)); 
               ATIO.Put_Line (Integer'Image(10*linecount) & " flt_offset_x = " & Float'Image (flt_offset_x) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " flt_offset_x = " & Float'Image (flt_offset_x) ); 
               
               gbl_flt_offset_x := flt_offset_x;
               
               
            end if;
            
            -- Y-axis Offset
            if (ubs_token = "#7") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
                              
               ubs_offset_y := ASU.To_Unbounded_String (GSS.Slice (substrings, 3));
               ATIO.Put_Line (Integer'Image(10*linecount) & " #7 ubs_offset_y = " & ASU.To_String (ubs_offset_y) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " #7 ubs_offset_y = " & ASU.To_String (ubs_offset_y) ); 
               
               flt_offset_y := Float'Value(ASU.To_String(ubs_offset_y)); 
               ATIO.Put_Line (Integer'Image(10*linecount) & " flt_offset_y = " & Float'Image (flt_offset_y) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " flt_offset_x = " & Float'Image (flt_offset_y) ); 
               
               gbl_flt_offset_y := flt_offset_y;
                 
            end if;
                        
            -- Z-axis Offset
            if (ubs_token = "#8") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               
               ubs_offset_z := ASU.To_Unbounded_String (GSS.Slice (substrings, 3));
               ATIO.Put_Line (Integer'Image(10*linecount) & " #8 ubs_offset_z = " & ASU.To_String (ubs_offset_z) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " #8 ubs_offset_z = " & ASU.To_String (ubs_offset_z) ); 
               
                  
               flt_offset_z := Float'Value(ASU.To_String(ubs_offset_z)); 
               ATIO.Put_Line (Integer'Image(10*linecount) & " flt_offset_z = " & Float'Image (flt_offset_z) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " flt_offset_z = " & Float'Image (flt_offset_z) ); 
             
               gbl_flt_offset_z := flt_offset_z;
                             
            end if;
            
            -- XY-axis_scaling
            if (ubs_token = "#10") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               
               ubs_scaling_xy := ASU.To_Unbounded_String (GSS.Slice (substrings, 3));
               ATIO.Put_Line (Integer'Image(10*linecount) & " #10 ubs_scaling_xy = " & ASU.To_String (ubs_scaling_xy) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " #10 ubs_scaling_xy = " & ASU.To_String (ubs_scaling_xy) ); 
               
               flt_scaling_xy := Float'Value(ASU.To_String(ubs_scaling_xy)); 
               ATIO.Put_Line (Integer'Image(10*linecount) & " flt_scaling_xy = " & Float'Image (flt_scaling_xy) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " flt_scaling_xy = " & Float'Image (flt_scaling_xy) ); 
       
               gbl_flt_scaling_x := flt_scaling_xy;   
               gbl_flt_scaling_y := flt_scaling_xy;
               gbl_flt_scaling_i := gbl_flt_scaling_x;
               gbl_flt_scaling_j := gbl_flt_scaling_x;
               
            end if;
            
            -- Z-axis_scaling
            if (ubs_token = "#11") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               
               ubs_scaling_z := ASU.To_Unbounded_String (GSS.Slice (substrings, 3));
               ATIO.Put_Line (Integer'Image(10*linecount) & " #11 ubs_scaling_z = " & ASU.To_String (ubs_scaling_z) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " #11 ubs_scaling_z = " & ASU.To_String (ubs_scaling_z) ); 
               
               flt_scaling_z := Float'Value(ASU.To_String(ubs_scaling_z)); 
               ATIO.Put_Line (Integer'Image(10*linecount) & " flt_scaling_z = " & Float'Image (flt_scaling_z) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " flt_scaling_z = " & Float'Image (flt_scaling_z) ); 
               
               gbl_flt_scaling_z := flt_scaling_z;
               
                    
            end if;
            
            -- Feed_definition 20
            if (ubs_token = "#20") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
              
               ubs_feedrate_20 := ASU.To_Unbounded_String (GSS.Slice (substrings, 3));
               ATIO.Put_Line (Integer'Image(10*linecount) & " #20 feedrate_20 = " & ASU.To_String (ubs_feedrate_20) );   
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " #20 feedrate_20 = " & ASU.To_String (ubs_feedrate_20) );  
               
               flt_feedrate_20 := Float'Value(ASU.To_String(ubs_feedrate_20)); 
               ATIO.Put_Line (Integer'Image(10*linecount) & " flt_feedrate_20 = " & Float'Image (flt_feedrate_20) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " flt_feedrate_20 = " & Float'Image (flt_feedrate_20) ); 
                              
               gbl_flt_feedrate_20 := flt_feedrate_20;
               
            end if;
            
            -- Feed_definition 21
            if (ubs_token = "#21") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
                             
               ubs_feedrate_21 := ASU.To_Unbounded_String (GSS.Slice (substrings, 3));
               ATIO.Put_Line (Integer'Image(10*linecount) & " #21 feedrate_21 = " & ASU.To_String (ubs_feedrate_21) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " #21 feedrate_21 = " & ASU.To_String (ubs_feedrate_21) );   
               
               flt_feedrate_21 := Float'Value(ASU.To_String(ubs_feedrate_21)); 
               ATIO.Put_Line (Integer'Image(10*linecount) & " flt_feedrate_21 = " & Float'Image (flt_feedrate_21) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " flt_feedrate_21 = " & Float'Image (flt_feedrate_21) ); 
               
               gbl_flt_feedrate_21 := flt_feedrate_21;
            
            end if;
                    
            
            -- (3) MOTION CODES ===================================================
            if (ubs_token = "G00") then
               ubs_action := ubs_token;               
               vubs_action := ubs_action;
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsaction = " & ASU.To_String (ubs_action) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsaction = " & ASU.To_String (ubs_action) );
            
            end if;   
            
            if (ubs_token = "G01") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsaction = " & ASU.To_String (ubs_action) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsaction = " & ASU.To_String (ubs_action) );
               
            end if;   
            
            if (ubs_token = "G02") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsaction = " & ASU.To_String (ubs_action) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsaction = " & ASU.To_String (ubs_action) );
            
            end if;   
            
            if (ubs_token = "G03") then
               ubs_action := ubs_token;
               vubs_action := ubs_action;
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsaction = " & ASU.To_String (ubs_action) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsaction = " & ASU.To_String (ubs_action) );
            
            end if;   
            
            -- (4) POINT COORDINATE CODES =========================================
            -- FOR first character X
            if (ASU.Slice(ubs_token, 1, 1) = "X") then
               ubsnext_x := ubs_token;
               
               if ASU.Slice(ubs_token, 1, 2) = "X[" then
               
                             
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsnext_x = " & ASU.To_String (ubsnext_x) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsnext_x = " & ASU.To_String (ubsnext_x) );
               
               endNumberX := ASU.Index (ubsnext_x, "*");
               fltnext_x := Float'Value(ASU.Slice(ubsnext_x, 3, endNumberX-1));   
                  
               -- fltnext_x := Float'Value(ASU.Slice(ubsnext_x, 3, 7));
                  fltnext_x := (fltnext_x * gbl_flt_scaling_x) + gbl_flt_offset_x;
                  vfltnext_x := fltnext_x;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " fltnext_x = " & Float'Image (fltnext_x) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " fltnext_x = " & Float'Image (fltnext_x) ); 
            
               else
                  --  X0.0000
                  fltnext_x := Float'Value(ASU.Slice(ubsnext_x, 2, 7));
                  ATIO.Put_Line (Integer'Image(10*linecount) & " fltnext_x = " & Float'Image (fltnext_x) );
                  ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " fltnext_x = " & Float'Image (fltnext_x) );
                  vfltnext_x := fltnext_x;
                  
                 -- null;   
               end if;     
                  
                  
            end if;
                    
            -- FOR first character Y ===============================
            if (ASU.Slice(ubs_token, 1, 1) = "Y") then
               ubsnext_y := ubs_token;
               
               if ASU.Slice(ubs_token, 1, 2) = "Y[" then
                             
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsnext_y = " & ASU.To_String (ubsnext_y) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsnext_y = " & ASU.To_String (ubsnext_y) );
                  
               endNumberY := ASU.Index (ubsnext_y, "*");
               fltnext_y := Float'Value(ASU.Slice(ubsnext_y, 3, endNumberY-1));      
               
               -- fltnext_y := Float'Value(ASU.Slice(ubsnext_y, 3, 7));
                  fltnext_y := (fltnext_y * gbl_flt_scaling_y) + gbl_flt_offset_y;
                  vfltnext_y := fltnext_y;
                  
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " fltnext_y = " & Float'Image (fltnext_y) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " fltnext_y = " & Float'Image (fltnext_y) ); 
               
               else
                  --  Y0.0000
                  fltnext_y := Float'Value(ASU.Slice(ubsnext_y, 2, 7));
                  ATIO.Put_Line (Integer'Image(10*linecount) & " fltnext_y = " & Float'Image (fltnext_y) );
                  ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " fltnext_y = " & Float'Image (fltnext_y) );
                  vfltnext_y := fltnext_y;
                  
                 -- null;   
               end if;      
                        
            end if;
            
            -- FOR first character Z =============================
            if (ASU.Slice(ubs_token, 1, 1) = "Z") then
               ubsnext_z := ubs_token;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsnext_z = " & ASU.To_String (ubsnext_z) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsnext_z = " & ASU.To_String (ubsnext_z) );
               
               endNumberZ := ASU.Index (ubsnext_z, "*");
               fltnext_z := Float'Value(ASU.Slice(ubsnext_z, 3, endNumberZ-1));   
               
               -- fltnext_z := Float'Value(ASU.Slice(ubsnext_z, 3, 7));
               fltnext_z := (fltnext_z * gbl_flt_scaling_z) + gbl_flt_offset_z;
               vfltnext_z := fltnext_z;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " fltnext_z = " & Float'Image (fltnext_z) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " fltnext_z = " & Float'Image (fltnext_z) ); 
               
                                   
            end if;
            
            -- FOR first character I ===============================
            if (ASU.Slice(ubs_token, 1, 1) = "I") then
               ubsnext_i:= ubs_token;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsnext_i = " & ASU.To_String (ubsnext_i) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsnext_i = " & ASU.To_String (ubsnext_i) );
            
               endNumberI := ASU.Index (ubsnext_i, "*");
               fltnext_i := Float'Value(ASU.Slice(ubsnext_i, 3, endNumberI-1));   
               
               -- fltnext_i := Float'Value(ASU.Slice(ubsnext_i, 3, 7));
               fltnext_i := (fltnext_i * gbl_flt_scaling_i);
               vfltnext_i := fltnext_i;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " fltnext_i = " & Float'Image (fltnext_i) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " fltnext_i = " & Float'Image (fltnext_i) ); 
                         
               
            end if;
                        
            -- FOR first character J
            if (ASU.Slice(ubs_token, 1, 1) = "J") then
               ubsnext_j := ubs_token;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsnext_j = " & ASU.To_String (ubsnext_j) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsnext_j = " & ASU.To_String (ubsnext_j) );
               
               endNumberJ := ASU.Index (ubsnext_j, "*");
               fltnext_j := Float'Value(ASU.Slice(ubsnext_j, 3, endNumberJ-1));   
               
               -- fltnext_j := Float'Value(ASU.Slice(ubsnext_j, 3, 7));
               fltnext_j := (fltnext_j * gbl_flt_scaling_j);
               vfltnext_j := fltnext_j;
               
               ATIO.Put_Line (Integer'Image(10*linecount) & " fltnext_j = " & Float'Image (fltnext_j) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " fltnext_j = " & Float'Image (fltnext_j) ); 
                         
               
            end if;
            
            -- FOR first character F FOR F[#20] AND F[#21]
            if (ASU.Slice(ubs_token, 1, 1) = "F") then
               ubsnext_f := ubs_token;
                              
               ATIO.Put_Line (Integer'Image(10*linecount) & " ubsnext_f = " & ASU.To_String (ubsnext_f) );
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " ubsnext_f = " & ASU.To_String (ubsnext_f) );
            
               
               if (ASU.Slice(ubsnext_f, 4, 5) = "20") then
                  fltnext_f := gbl_flt_feedrate_20;
                  vfltnext_f := fltnext_f;
               end if;
               
               if (ASU.Slice(ubsnext_f, 4, 5) = "21") then
                  fltnext_f := gbl_flt_feedrate_21;
                  vfltnext_f := fltnext_f;
               end if;
                              
               ATIO.Put_Line (Integer'Image(10*linecount) & " fltnext_f = " & Float'Image (fltnext_f) ); 
               ATIO.Put_Line (out_fhandle_03, Integer'Image(10*linecount) & " fltnext_f = " & Float'Image (fltnext_f) ); 
               
            end if;
         
       
         end;
        
      end loop;
      
       -- ================================================================
       -- FOR EACH LINE PROCESSED
       -- ================================================================
       -- WRITE VECTOR LINE TO OUTPUT FILE
      
       if (vubs_action = "G00") or (vubs_action = "G01") then
          vfltnext_i := 0.0;
          vfltnext_j := 0.0;
       end if; 
      
       ATIO.Put_Line (out_fhandle_04, Integer'Image(10*linecount) 
                     & " " & ASU.To_String(vubs_action) 
                     & " " & Float'Image(vfltnext_x)
                     & " " & Float'Image(vfltnext_y)
                     & " " & Float'Image(vfltnext_z)
                     & " " & Float'Image(vfltnext_i)
                     & " " & Float'Image(vfltnext_j)  
                     & " " & Float'Image(vfltnext_f)    
                    ); 
      
  
   end vectorize_eachline;
  
   
-- ========================================================
begin -- PACKAGE BEGIN
   null;
-- ========================================================
end pkg_ada_vectorize_splitline;
-- ========================================================
