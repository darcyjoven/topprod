/*
================================================================================
檔案代號:sgk_file
檔案名稱:飞票报工档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgk_file
(
sgk01       varchar2(20) DEFAULT ' ' NOT NULL, /*报工单号*/
sgk02       date DEFAULT sysdate NOT NULL, /*报工日期*/
sgk03       varchar2(10) DEFAULT ' ' NOT NULL, /*报工人员*/
sgk04       varchar2(80) DEFAULT ' ' NOT NULL, /*備注*/
sgk05       varchar2(1) DEFAULT ' ' NOT NULL, /*飞票报工否*/
sgk06       varchar2(1) DEFAULT ' ' NOT NULL, /*团体报工否*/
sgk07       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
sgkacti     varchar2(1),             /*资料有效码                             */
sgkdate     date,                    /*资料更改日期                           */
sgkgrup     varchar2(10),            /*资料所属群组                           */
sgkmodu     varchar2(10),            /*资料更改者                             */
sgkuser     varchar2(10),            /*资料所有者                             */
sgkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgklegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgkorig     varchar2(10),            /*资料建立部门                           */
sgkoriu     varchar2(10)             /*资料建立者                             */
);

alter table sgk_file add  constraint sgk_pk primary key  (sgk01) enable validate;
grant select on sgk_file to tiptopgp;
grant update on sgk_file to tiptopgp;
grant delete on sgk_file to tiptopgp;
grant insert on sgk_file to tiptopgp;
grant index on sgk_file to public;
grant select on sgk_file to ods;
