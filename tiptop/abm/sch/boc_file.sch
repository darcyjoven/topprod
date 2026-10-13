/*
================================================================================
檔案代號:boc_file
檔案名稱:成品材料属性对应关系
檔案目的:成品材料属性对应关系单头档  双档单头
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table boc_file
(
boc01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件款式*/
boc02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件款式*/
boc03       varchar2(10) DEFAULT ' ' NOT NULL, /*主件属性代码*/
boc04       varchar2(10) DEFAULT ' ' NOT NULL, /*元件属性代码*/
bocacti     varchar2(1),             /*资料有效码                             */
bocdate     date,                    /*资料更改日期                           */
bocgrup     varchar2(10),            /*资料所属群组                           */
bocmodu     varchar2(10),            /*资料更改者                             */
bocuser     varchar2(10),            /*资料用户                               */
bocoriu     varchar2(10),            /*资料建立者                             */
bocorig     varchar2(10)             /*资料建立部门                           */
);

alter table boc_file add  constraint boc_pk primary key  (boc01,boc02,boc03,boc04) enable validate;
grant select on boc_file to tiptopgp;
grant update on boc_file to tiptopgp;
grant delete on boc_file to tiptopgp;
grant insert on boc_file to tiptopgp;
grant index on boc_file to public;
grant select on boc_file to ods;
