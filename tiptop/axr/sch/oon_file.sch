/*
================================================================================
檔案代號:oon_file
檔案名稱:电子发票簿文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oon_file
(
oon01       number(5) DEFAULT '0' NOT NULL, /*发票年度*/
oon02       number(5) DEFAULT '0' NOT NULL, /*发票月份-起始*/
oon03       number(5) DEFAULT '0' NOT NULL, /*发票月份-截止*/
oon04       varchar2(20) DEFAULT ' ' NOT NULL, /*起始发票号码*/
oon05       varchar2(20) DEFAULT ' ' NOT NULL, /*截止发票号码*/
oon06       varchar2(20) DEFAULT ' ' NOT NULL, /*申报税号*/
oon07       number(5) DEFAULT '0' NOT NULL, /*批量*/
oon08       varchar2(1) DEFAULT ' ' NOT NULL, /*已产生发票簿否*/
oondate     date,                    /*最近更改日                             */
oongrup     varchar2(10),            /*资料所有群                             */
oonmodu     varchar2(10),            /*资料更改者                             */
oonorig     varchar2(10),            /*资料建立部门                           */
oonoriu     varchar2(10),            /*资料建立者                             */
oonuser     varchar2(10)             /*资料所有者                             */
);

alter table oon_file add  constraint oon_pk primary key  (oon01,oon02,oon03,oon04) enable validate;
grant select on oon_file to tiptopgp;
grant update on oon_file to tiptopgp;
grant delete on oon_file to tiptopgp;
grant insert on oon_file to tiptopgp;
grant index on oon_file to public;
grant select on oon_file to ods;
