-- File   : pkg_ada_linestring_split.ads
-- Date   : Sun 07 Mar 2021 06:00:42 PM +08
-- Author : wruslandr@gmail.com
-- Version: 1.0 Sun 07 Mar 2021 06:00:42 PM +08
-- ========================================================
with Ada.Real_Time;         
use  Ada.Real_Time;
with Ada.Text_IO;

-- ======================================================== 
package pkg_ada_linestring_split 
-- ========================================================
    with SPARK_Mode => on
is
   
   package AART  renames Ada.Real_Time;
   package AATIO renames Ada.Text_IO;
   
   procedure tokenize_line (linestring : in String; out_fhandle_02 : in AATIO.File_Type; linecount: Integer);
  

   procedure about_package;
-- ======================================================== 
end pkg_ada_linestring_split;
-- ========================================================

