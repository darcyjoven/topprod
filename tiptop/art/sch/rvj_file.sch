/*
================================================================================
檔案代號:rvj_file
檔案名稱:配送出货门号资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rvj_file
(
rvj01       varchar2(10) DEFAULT ' ' NOT NULL, /*出货门号*/
rvj02       varchar2(80),            /*说明                                   */
rvj03       varchar2(10),            /*归属配送中心                           */
rvjacti     varchar2(1),             /*资料有效码                             */
rvjcrat     date,                    /*资料创建日                             */
rvjdate     date,                    /*最近更改日                             */
rvjgrup     varchar2(10),            /*资料所有部门                           */
rvjmodu     varchar2(10),            /*资料更改者                             */
rvjuser     varchar2(10),            /*资料所有者                             */
rvjorig     varchar2(10),            /*资料建立部门                           */
rvjoriu     varchar2(10)             /*资料建立者                             */
);

alter table rvj_file add  constraint rvj_pk primary key  (rvj01) enable validate;
grant select on rvj_file to tiptopgp;
grant update on rvj_file to tiptopgp;
grant delete on rvj_file to tiptopgp;
grant insert on rvj_file to tiptopgp;
grant index on rvj_file to public;
grant select on rvj_file to ods;
