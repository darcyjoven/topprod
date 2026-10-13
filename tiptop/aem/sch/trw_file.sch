/*
================================================================================
檔案代號:trw_file
檔案名稱:员工工种资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table trw_file
(
trw01       varchar2(6) NOT NULL,    /*工种编号                               */
trw02       varchar2(80),            /*说明                                   */
trwacti     varchar2(1),             /*资料有效否                             */
trwuser     varchar2(10),            /*资料所有者                             */
trwgrup     varchar2(10),            /*资料所有部门                           */
trwmodu     varchar2(10),            /*资料更改者                             */
trwdate     date,                    /*最近更改日                             */
trworig     varchar2(10),            /*资料建立部门                           */
trworiu     varchar2(10)             /*资料建立者                             */
);

alter table trw_file add  constraint trw_pk primary key  (trw01) enable validate;
grant select on trw_file to tiptopgp;
grant update on trw_file to tiptopgp;
grant delete on trw_file to tiptopgp;
grant insert on trw_file to tiptopgp;
grant index on trw_file to public;
grant select on trw_file to ods;
