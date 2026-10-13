/*
================================================================================
檔案代號:ozc_file
檔案名稱:运输方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ozc_file
(
ozc01       varchar2(1) NOT NULL,    /*运输模式                               */
ozc02       varchar2(80),            /*运输方式说明                           */
ozcacti     varchar2(1),             /*资料有效码                             */
ozcuser     varchar2(10),            /*资料所有者                             */
ozcgrup     varchar2(10),            /*资料所有群                             */
ozcmodu     varchar2(10),            /*资料更改者                             */
ozcdate     date,                    /*最近更改日                             */
ozcorig     varchar2(10),            /*资料建立部门                           */
ozcoriu     varchar2(10)             /*资料建立者                             */
);

alter table ozc_file add  constraint ozc_pk primary key  (ozc01) enable validate;
grant select on ozc_file to tiptopgp;
grant update on ozc_file to tiptopgp;
grant delete on ozc_file to tiptopgp;
grant insert on ozc_file to tiptopgp;
grant index on ozc_file to public;
grant select on ozc_file to ods;
