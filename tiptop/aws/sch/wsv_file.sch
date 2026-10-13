/*
================================================================================
檔案代號:wsv_file
檔案名稱:MDM table及流程关联记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsv_file
(
wsv01       varchar2(20) NOT NULL,   /*程序编号                               */
wsv02       varchar2(20) NOT NULL,   /*档案代码                               */
wsv03       varchar2(1),             /*档案类型                               */
wsv04       varchar2(40),            /*MDM档案代号                            */
wsv05       varchar2(40),            /*MDM流程名称                            */
wsv06       number(10)               /*单次传送最大笔数                       */
);

alter table wsv_file add  constraint wsv_pk primary key  (wsv01,wsv02) enable validate;
grant select on wsv_file to tiptopgp;
grant update on wsv_file to tiptopgp;
grant delete on wsv_file to tiptopgp;
grant insert on wsv_file to tiptopgp;
grant index on wsv_file to public;
grant select on wsv_file to ods;
