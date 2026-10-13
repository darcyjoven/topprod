/*
================================================================================
檔案代號:gaa_file
檔案名稱:常用程序计录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gaa_file
(
gaa01       varchar2(10) NOT NULL,   /*用户编号                               */
gaa02       varchar2(20) NOT NULL,   /*程序编号                               */
gaa03       date,                    /*运行日期                               */
gaa04       varchar2(8)              /*运行时间                               */
);

create        index gaa_01 on gaa_file (gaa01,gaa02);
alter table gaa_file add  constraint gaa_pk primary key  (gaa01,gaa02) enable validate;
grant select on gaa_file to tiptopgp;
grant update on gaa_file to tiptopgp;
grant delete on gaa_file to tiptopgp;
grant insert on gaa_file to tiptopgp;
grant index on gaa_file to public;
grant select on gaa_file to ods;
