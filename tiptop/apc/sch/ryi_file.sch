/*
================================================================================
檔案代號:ryi_file
檔案名稱:POS使用者资料维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryi_file
(
ryi00       varchar2(10) DEFAULT ' ',/*no use                                 */
ryi01       varchar2(10) DEFAULT ' ' NOT NULL, /*POS用户*/
ryi02       varchar2(30),            /*员工编号                               */
ryi03       varchar2(40),            /*口令                                   */
ryi04       varchar2(1),             /*职能                                   */
ryi05       number(5),               /*no use                                 */
ryiacti     varchar2(1),             /*资料有效码                             */
ryicrat     date,                    /*资料创建日                             */
ryidate     date,                    /*最近更改日                             */
ryigrup     varchar2(10),            /*资料所有部门                           */
ryimodu     varchar2(10),            /*资料更改者                             */
ryipos      varchar2(1) DEFAULT '1', /*已传POS否                              */
ryiuser     varchar2(10),            /*资料所有者                             */
ryiorig     varchar2(10),            /*资料建立部门                           */
ryioriu     varchar2(10),            /*资料建立者                             */
ryi06       number(5),               /*no use                                 */
ryi07       varchar2(10)             /*权限编号                               */
);

alter table ryi_file add  constraint ryi_pk primary key  (ryi01) enable validate;
grant select on ryi_file to tiptopgp;
grant update on ryi_file to tiptopgp;
grant delete on ryi_file to tiptopgp;
grant insert on ryi_file to tiptopgp;
grant index on ryi_file to public;
grant select on ryi_file to ods;
