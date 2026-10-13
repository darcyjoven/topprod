/*
================================================================================
檔案代號:hjr_file
檔案名稱:GPRebuild信息
檔案目的:Record Rebuild Log
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hjr_file
(
hjr01       varchar2(10) DEFAULT ' ' NOT NULL, /*建置ID*/
hjr02       varchar2(1) DEFAULT ' ' NOT NULL, /*建置項目 C,L,F*/
hjr03       varchar2(10) DEFAULT ' ' NOT NULL, /*建置模組*/
hjr04       number(10) DEFAULT '0' NOT NULL, /*建置序號*/
hjr05       varchar2(1500),          /*错误信息                               */
hjr06       varchar2(1),             /*是否完成處理                           */
hjr07       varchar2(40),            /*编译时间及其他记录                     */
hjr08       varchar2(20)             /*程序代码                               */
);

alter table hjr_file add  constraint hjr_pk primary key  (hjr01,hjr02,hjr03,hjr04) enable validate;
grant select on hjr_file to tiptopgp;
grant update on hjr_file to tiptopgp;
grant delete on hjr_file to tiptopgp;
grant insert on hjr_file to tiptopgp;
grant index on hjr_file to public;
grant select on hjr_file to ods;
