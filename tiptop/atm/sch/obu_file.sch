/*
================================================================================
檔案代號:obu_file
檔案名稱:车辆保养项目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obu_file
(
obu01       varchar2(4) NOT NULL,    /*维护项目                               */
obu02       varchar2(80),            /*说明                                   */
obu03       varchar2(1),             /*类型                                   */
obu04       varchar2(80),            /*保养内容一                             */
obu05       varchar2(80),            /*保养内容二                             */
obu06       varchar2(80),            /*保养内容三                             */
obu07       varchar2(80),            /*保养内容四                             */
obuacti     varchar2(1),             /*资料有效码                             */
obuuser     varchar2(10),            /*资料所有者                             */
obugrup     varchar2(10),            /*资料所有部门                           */
obumodu     varchar2(10),            /*资料更改者                             */
obudate     date,                    /*最近更改日                             */
obuoriu     varchar2(10),            /*资料建立者                             */
obuorig     varchar2(10)             /*资料建立部门                           */
);

alter table obu_file add  constraint obu_pk primary key  (obu01) enable validate;
grant select on obu_file to tiptopgp;
grant update on obu_file to tiptopgp;
grant delete on obu_file to tiptopgp;
grant insert on obu_file to tiptopgp;
grant index on obu_file to public;
grant select on obu_file to ods;
