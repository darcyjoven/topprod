/*
================================================================================
檔案代號:sib_file
檔案名稱:工单备置单身档一
檔案目的:
上游檔案:sia_file
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sib_file
(
sib01       varchar2(20) DEFAULT ' ' NOT NULL, /*備置單號*/
sib02       varchar2(20) DEFAULT ' ' NOT NULL, /*工单单号*/
sib03       number(15,3) DEFAULT '0' NOT NULL,
sib04       varchar2(10),            /*作业序号                               */
siblegal    varchar2(10) NOT NULL,   /*所属法人                               */
sibplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table sib_file add  constraint sib_pk primary key  (sib01,sib02) enable validate;
grant select on sib_file to tiptopgp;
grant update on sib_file to tiptopgp;
grant delete on sib_file to tiptopgp;
grant insert on sib_file to tiptopgp;
grant index on sib_file to public;
grant select on sib_file to ods;
