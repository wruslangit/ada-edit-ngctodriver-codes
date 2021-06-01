-- File   : pkg_ada_cnc_driver_codes.ads
-- Date   : Tue 01 Jun 2021 12:41:11 PM +08
-- Author : wruslandr@gmail.com
-- Version: 1.0 Sun 30 May 2021 05:11:11 PM +08
-- ========================================================
with Ada.Real_Time;         
use  Ada.Real_Time;
with Ada.Text_IO;

-- ======================================================== 
package pkg_ada_cnc_driver_codes 
-- ========================================================
    with SPARK_Mode => on
is
   
   package AART  renames Ada.Real_Time;
   package AATIO renames Ada.Text_IO;
   
     
   -- READ FROM fhandle_01 THEN WRITE TO fhandle_02 
   procedure remove_gcode_comments(linestring : in String; 
                                 out_fhandle_02 : in AATIO.File_Type; 
                                 linecount: Integer);
   
   -- READ FROM fhandle_02 THEN WRITE TO fhandle_03 
   procedure create_gcode_action_file;
   
   
   
-- ======================================================== 
end pkg_ada_cnc_driver_codes;
-- ========================================================

