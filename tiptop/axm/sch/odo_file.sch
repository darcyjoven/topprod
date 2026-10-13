/*
================================================================================
檔案代號:odo_file
檔案名稱:订货会目标档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odo_file
(
odo01       varchar2(10) DEFAULT ' ' NOT NULL, /*訂購會編號*/
odo02       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
odo03       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
odo04       number(15,3) DEFAULT '0' NOT NULL, /*金额*/
odoacti     varchar2(1),             /*资料有效码                             */
ododate     date,                    /*最近更改日                             */
odogrup     varchar2(10),            /*资料所有部门                           */
odomodu     varchar2(10),            /*资料更改者                             */
odoorig     varchar2(10),            /*资料建立部门                           */
odooriu     varchar2(10),            /*资料建立者                             */
odouser     varchar2(10)             /*资料所有者                             */
);

alter table odo_file add  constraint odo_pk primary key  (odo01,odo02) enable validate;
grant select on odo_file to tiptopgp;
grant update on odo_file to tiptopgp;
grant delete on odo_file to tiptopgp;
grant insert on odo_file to tiptopgp;
grant index on odo_file to public;
grant select on odo_file to ods;
