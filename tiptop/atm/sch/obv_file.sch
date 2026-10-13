/*
================================================================================
檔案代號:obv_file
檔案名稱:车辆保养群组档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obv_file
(
obv01       varchar2(4) NOT NULL,    /*保养群组                               */
obv012      varchar2(80),            /*说明                                   */
obv02       number(5) NOT NULL,      /*项次                                   */
obv03       varchar2(4),             /*保养项目                               */
obvacti     varchar2(1),             /*资料有效码                             */
obvuser     varchar2(10),            /*资料所有者                             */
obvgrup     varchar2(10),            /*资料所有部门                           */
obvmodu     varchar2(10),            /*资料更改者                             */
obvdate     date,                    /*最近更改日                             */
obv04       number(10),              /*里程公里数                             */
obv05       number(5),               /*行驶年数                               */
obvorig     varchar2(10),            /*资料建立部门                           */
obvoriu     varchar2(10)             /*资料建立者                             */
);

alter table obv_file add  constraint obv_pk primary key  (obv01,obv02) enable validate;
grant select on obv_file to tiptopgp;
grant update on obv_file to tiptopgp;
grant delete on obv_file to tiptopgp;
grant insert on obv_file to tiptopgp;
grant index on obv_file to public;
grant select on obv_file to ods;
