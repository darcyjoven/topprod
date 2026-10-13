/*
================================================================================
檔案代號:rvi_file
檔案名稱:运输线路分类资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rvi_file
(
rvi01       varchar2(10) DEFAULT ' ' NOT NULL, /*分类编号*/
rvi02       varchar2(80),            /*分类名称                               */
rviacti     varchar2(1),             /*资料有效码                             */
rvicrat     date,                    /*资料创建日                             */
rvidate     date,                    /*最近更改日                             */
rvigrup     varchar2(10),            /*资料所有部门                           */
rvimodu     varchar2(10),            /*资料更改者                             */
rviuser     varchar2(10),            /*资料所有者                             */
rviorig     varchar2(10),            /*资料建立部门                           */
rvioriu     varchar2(10)             /*资料建立者                             */
);

alter table rvi_file add  constraint rvi_pk primary key  (rvi01) enable validate;
grant select on rvi_file to tiptopgp;
grant update on rvi_file to tiptopgp;
grant delete on rvi_file to tiptopgp;
grant insert on rvi_file to tiptopgp;
grant index on rvi_file to public;
grant select on rvi_file to ods;
