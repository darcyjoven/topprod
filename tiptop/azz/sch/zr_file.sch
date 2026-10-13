/*
================================================================================
檔案代號:zr_file
檔案名稱:程序档案关连档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zr_file
(
zr01        varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式編號                               */
zr02        varchar2(15) NOT NULL,   /*档案编号                               */
                                     /*檔案編號                               */
zr03        varchar2(1) NOT NULL     /*异动别                                 */
                                     /*異動別 (Insert/Update/Delete/Select)   */
);

alter table zr_file add  constraint zr_pk primary key  (zr01,zr02,zr03) enable validate;
grant select on zr_file to tiptopgp;
grant update on zr_file to tiptopgp;
grant delete on zr_file to tiptopgp;
grant insert on zr_file to tiptopgp;
grant index on zr_file to public;
grant select on zr_file to ods;
