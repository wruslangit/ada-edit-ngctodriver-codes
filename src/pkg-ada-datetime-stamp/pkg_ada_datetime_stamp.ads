-- File: pkg_ada_datetime_stamp.ads
-- Date: Sun 20 Dec 2020 10:34:19 AM +08
-- Author: WRY
-- Version: 1.2 Fri 30 Oct 2020 10:17:22 AM +08

with Ada.Real_Time;         use Ada.Real_Time;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

-- ========================================================
package pkg_ada_datetime_stamp 
-- ========================================================
    with SPARK_Mode => on
is
   
   package AART renames Ada.Real_Time;
   package AASU renames Ada.Strings.Unbounded;
   
   -- USAGE
   -- FOR ClockNow, USE AART.Clock

   procedure dtstamp;
   function get_date_stamp (ClockNow : in AART.Time) return AASU.Unbounded_String; 
   function get_time_stamp (ClockNow : in AART.Time) return AASU.Unbounded_String;
 
   procedure about_package;
-- ======================================================== 
end pkg_ada_datetime_stamp;
-- ========================================================


