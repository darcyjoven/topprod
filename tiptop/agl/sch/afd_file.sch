/*
================================================================================
檔案代號:afd_file
檔案名稱:预算底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table afd_file
(
afd00       varchar2(10) DEFAULT ' ' NOT NULL, /*预算版本*/
afd01       varchar2(10) DEFAULT ' ' NOT NULL, /*预算营运中心*/
afd02       number(5) DEFAULT '0' NOT NULL, /*预算年度*/
afd03       varchar2(10) DEFAULT ' ' NOT NULL, /*预算部门*/
afd04       varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
afd05       varchar2(30) DEFAULT ' ' NOT NULL, /*wbs编码*/
afd06       varchar2(10) DEFAULT ' ' NOT NULL, /*预算项目*/
afd07       varchar2(24) DEFAULT ' ' NOT NULL, /*会计科目*/
afd08       varchar2(10),            /*编制人员                               */
afd09       varchar2(4),             /*预算币种                               */
afd10       number(20,6),            /*年预算金额                             */
afd11       varchar2(4),             /*预算币种(来源)                         */
afd12       number(20,6),            /*年预算金额(来源)                       */
afdacti     varchar2(1),             /*资料有效码                             */
afddate     date,                    /*最近更改日                             */
afdgrup     varchar2(10),            /*资料所有群                             */
afdmodu     varchar2(10),            /*资料更改者                             */
afduser     varchar2(10),            /*资料所有者                             */
afdoriu     varchar2(10),            /*资料建立者                             */
afdorig     varchar2(10)             /*资料建立部门                           */
);

alter table afd_file add  constraint afd_pk primary key  (afd00,afd01,afd02,afd03,afd04,afd05,afd06,afd07) enable validate;
grant select on afd_file to tiptopgp;
grant update on afd_file to tiptopgp;
grant delete on afd_file to tiptopgp;
grant insert on afd_file to tiptopgp;
grant index on afd_file to public;
grant select on afd_file to ods;
