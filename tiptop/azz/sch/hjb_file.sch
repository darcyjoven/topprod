/*
================================================================================
檔案代號:hjb_file
檔案名稱:tiptop gp函式功能动态记录表
檔案目的:系统函式功能动态记录
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hjb_file
(
hjb01       varchar2(40) DEFAULT ' ' NOT NULL, /*档案名称*/
hjb02       varchar2(80) NOT NULL,   /*函式名称                               */
hjb03       varchar2(1),
hjb04       varchar2(255),
hjb05       varchar2(255),
hjb06       varchar2(255),
hjb07       varchar2(255),
hjb08       varchar2(255),
hjbmodu     date,
hjbuser     varchar2(10),
hjborig     varchar2(10),            /*资料建立部门                           */
hjboriu     varchar2(10)             /*资料建立者                             */
);

alter table hjb_file add  constraint hjb_pk primary key  (hjb01,hjb02) enable validate;
grant select on hjb_file to tiptopgp;
grant update on hjb_file to tiptopgp;
grant delete on hjb_file to tiptopgp;
grant insert on hjb_file to tiptopgp;
grant index on hjb_file to public;
grant select on hjb_file to ods;
