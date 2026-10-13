/*
================================================================================
檔案代號:fbr_file
檔案名稱:资产停用异动单单身
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbr_file
(
fbr01       varchar2(16) DEFAULT ' ' NOT NULL, /*异动单号*/
fbr02       number(5) DEFAULT '0' NOT NULL, /*项次*/
fbr03       varchar2(10),            /*财产编号                               */
fbr031      varchar2(4),             /*附号                                   */
fbr04       varchar2(1) DEFAULT '0' NOT NULL, /*异动前资产状态*/
fbr05       varchar2(1) DEFAULT '0' NOT NULL, /*异动前税签资产状态*/
fbr06       varchar2(1) DEFAULT '0' NOT NULL, /*异动前财签二资产状态*/
fbrlegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table fbr_file add  constraint fbr_pk primary key  (fbr01,fbr02) enable validate;
grant select on fbr_file to tiptopgp;
grant update on fbr_file to tiptopgp;
grant delete on fbr_file to tiptopgp;
grant insert on fbr_file to tiptopgp;
grant index on fbr_file to public;
grant select on fbr_file to ods;
