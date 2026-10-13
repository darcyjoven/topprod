/*
================================================================================
檔案代號:hrea_file
檔案名稱:薪酬总额预算管理
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrea_file
(
hrea00      varchar2(20) NOT NULL,   /*预算年度                               */
hrea01      varchar2(20) NOT NULL,   /*预算类别                               */
hrea02      varchar2(20) NOT NULL,   /*关联薪资项目                           */
hrea03      varchar2(255),
hreaacti    varchar2(10),
hreagrup    varchar2(20),
hreauser    varchar2(20),
hreamodu    varchar2(20),
hreadate    date,
hreaoriu    varchar2(20),
hreaorig    varchar2(20),
hreaud01    varchar2(255),
hreaud02    varchar2(40),
hreaud03    varchar2(40),
hreaud04    varchar2(40),
hreaud05    varchar2(40),
hreaud06    varchar2(40),
hreaud07    number(5),
hreaud08    number(5),
hreaud09    number(5),
hreaud10    number(15,3),
hreaud11    number(15,3),
hreaud12    number(15,3),
hreaud13    date,
hreaud14    date,
hreaud15    date
);

alter table hrea_file add  constraint hrea_pk primary key  (hrea00,hrea01,hrea02) enable validate;
grant select on hrea_file to tiptopgp;
grant update on hrea_file to tiptopgp;
grant delete on hrea_file to tiptopgp;
grant insert on hrea_file to tiptopgp;
grant index on hrea_file to public;
grant select on hrea_file to ods;
