/*
================================================================================
檔案代號:azr_file
檔案名稱:营运中心使用系统关连档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azr_file
(
azr01       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*工廠編號    (FROM)                     */
azr02       varchar2(20) NOT NULL,   /*营运中心使用系统                       */
                                     /*工廠使用系統(FROM)                     */
azr03       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*工廠編號    ( TO )                     */
azr04       varchar2(20) NOT NULL    /*营运中心使用系统                       */
                                     /*工廠使用系統( TO )                     */
);

alter table azr_file add  constraint azr_pk primary key  (azr01,azr02,azr03,azr04) enable validate;
grant select on azr_file to tiptopgp;
grant update on azr_file to tiptopgp;
grant delete on azr_file to tiptopgp;
grant insert on azr_file to tiptopgp;
grant index on azr_file to public;
grant select on azr_file to ods;
