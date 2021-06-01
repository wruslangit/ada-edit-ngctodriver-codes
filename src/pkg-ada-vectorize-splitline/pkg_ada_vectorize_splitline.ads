-- File   : pkg_ada_vectorize_splitline.ads
-- Date   : Sun 30 May 2021 05:11:11 PM +08
-- Author : wruslandr@gmail.com
-- Version: 1.0 Sun 30 May 2021 05:11:11 PM +08
-- ========================================================
with Ada.Real_Time;         
use  Ada.Real_Time;
with Ada.Text_IO;

-- ======================================================== 
package pkg_ada_vectorize_splitline 
-- ========================================================
    with SPARK_Mode => on
is
   
   package AART  renames Ada.Real_Time;
   package AATIO renames Ada.Text_IO;
   
   procedure vectorize_eachline (linestring : in String; 
                                 out_fhandle_02, out_fhandle_03, out_fhandle_04 : in AATIO.File_Type; 
                                 linecount: Integer);
     
   
-- ======================================================== 
end pkg_ada_vectorize_splitline;
-- ========================================================

