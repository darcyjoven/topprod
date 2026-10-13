/*
================================================================================
檔案代號:imab_file
檔案名稱:主档抛转记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imab_file
(
imab00      varchar2(1) NOT NULL,    /*申请类型(I:新增 U:更改)                */
imabno      varchar2(80) NOT NULL,   /*申请单号                               */
imab01      varchar2(40) NOT NULL,   /*申请料件/客户/厂商编号                 */
imabtype    varchar2(1) NOT NULL,    /*主档类型(1:料号 2:客户 3:厂商)         */
imabdate    date,                    /*抛转日期                               */
imabdb      varchar2(20) NOT NULL    /*抛转数据库代码                         */
);

alter table imab_file add  constraint imab_pk primary key  (imabno,imabtype,imabdb) enable validate;
grant select on imab_file to tiptopgp;
grant update on imab_file to tiptopgp;
grant delete on imab_file to tiptopgp;
grant insert on imab_file to tiptopgp;
grant index on imab_file to public;
grant select on imab_file to ods;
