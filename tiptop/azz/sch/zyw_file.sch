/*
================================================================================
檔案代號:zyw_file
檔案名稱:权限群组资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table zyw_file
(
zyw01       varchar2(6) NOT NULL,    /*权限群组编号                           */
zyw02       varchar2(80),            /*权限群组名称                           */
zyw03       varchar2(10) NOT NULL,   /*部门编号                               */
zyw04       varchar2(10) DEFAULT ' ' NOT NULL, /*管理人员工号*/
zyw05       varchar2(1) NOT NULL,    /*部门或人员指标                         */
zyw06       varchar2(1),             /*No Use                                 */
zyw07       varchar2(1),             /*No Use                                 */
zyw08       varchar2(1),             /*No Use                                 */
zywacti     varchar2(1),             /*资料有效码                             */
zywuser     varchar2(10),            /*资料所有者                             */
zywgrup     varchar2(10),            /*资料所有部门                           */
zywmodu     varchar2(10),            /*资料更改者                             */
zywdate     date,                    /*最近更改日                             */
zyworig     varchar2(10),            /*资料建立部门                           */
zyworiu     varchar2(10)             /*资料建立者                             */
);

alter table zyw_file add  constraint zyw_pk primary key  (zyw01,zyw03,zyw04,zyw05) enable validate;
grant select on zyw_file to tiptopgp;
grant update on zyw_file to tiptopgp;
grant delete on zyw_file to tiptopgp;
grant insert on zyw_file to tiptopgp;
grant index on zyw_file to public;
grant select on zyw_file to ods;
