/*
================================================================================
檔案代號:vma_file
檔案名稱:APS工作模式维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vma_file
(
vma01       varchar2(60) DEFAULT ' ' NOT NULL, /*工作模式编号*/
vma02       number(9) DEFAULT '0' NOT NULL, /*开始时间(整数)*/
vma03       number(9) DEFAULT '0' NOT NULL, /*结束时间(整数)*/
vma04       number(1),               /*工作类型                               */
vma05       varchar2(60),            /*工作模式名称                           */
vma06       varchar2(60)             /*工作模式描述                           */
);

alter table vma_file add  constraint vma_pk primary key  (vma01,vma02) enable validate;
grant select on vma_file to tiptopgp;
grant update on vma_file to tiptopgp;
grant delete on vma_file to tiptopgp;
grant insert on vma_file to tiptopgp;
grant index on vma_file to public;
grant select on vma_file to ods;
