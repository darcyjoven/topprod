/*
================================================================================
檔案代號:noc_file
檔案名稱:接口银行编码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table noc_file
(
noc01       varchar2(10) DEFAULT ' ' NOT NULL, /*接口银行编码*/
noc02       varchar2(80),            /*说明                                   */
nocacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
nocdate     date,                    /*最近更改日                             */
nocgrup     varchar2(10),            /*资料所有部门                           */
nocmodu     varchar2(10),            /*资料更改者                             */
nocorig     varchar2(10),            /*资料建立部门                           */
nocoriu     varchar2(10),            /*资料建立者                             */
nocuser     varchar2(10)             /*资料所有者                             */
);

alter table noc_file add  constraint noc_pk primary key  (noc01) enable validate;
grant select on noc_file to tiptopgp;
grant update on noc_file to tiptopgp;
grant delete on noc_file to tiptopgp;
grant insert on noc_file to tiptopgp;
grant index on noc_file to public;
grant select on noc_file to ods;
