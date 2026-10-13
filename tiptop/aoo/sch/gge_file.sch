/*
================================================================================
檔案代號:gge_file
檔案名稱:库存异动类别理由码档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gge_file
(
gge01       varchar2(10) DEFAULT ' ' NOT NULL, /*模板编号*/
gge02       varchar2(255),           /*模板说明                               */
gge03       number(5) DEFAULT '0' NOT NULL, /*序号*/
gge04       varchar2(1) DEFAULT ' ' NOT NULL, /*出入库  0:出库  1.入库*/
gge05       varchar2(10),            /*异动类型                               */
gge06       varchar2(10),            /*理由码                                 */
ggeacti     varchar2(1) NOT NULL,    /*资料有效码                             */
ggedate     date,                    /*最近更改日                             */
ggegrup     varchar2(10),            /*资料所有群                             */
ggemodu     varchar2(10),            /*资料更改者                             */
ggeorig     varchar2(10),            /*资料建立部门                           */
ggeoriu     varchar2(10),            /*资料建立者                             */
ggeuser     varchar2(10)             /*资料所有者                             */
);

alter table gge_file add  constraint gge_pk primary key  (gge01,gge03) enable validate;
grant select on gge_file to tiptopgp;
grant update on gge_file to tiptopgp;
grant delete on gge_file to tiptopgp;
grant insert on gge_file to tiptopgp;
grant index on gge_file to public;
grant select on gge_file to ods;
