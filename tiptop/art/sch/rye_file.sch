/*
================================================================================
檔案代號:rye_file
檔案名稱:单据默认单别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rye_file
(
rye01       varchar2(3) DEFAULT ' ' NOT NULL, /*系统*/
rye02       varchar2(2) DEFAULT ' ' NOT NULL, /*单据性质*/
rye03       varchar2(5) DEFAULT ' ' NOT NULL, /*缺省单别*/
ryeacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ryecrat     date,                    /*资料创建日                             */
ryedate     date,                    /*最近更改日                             */
ryegrup     varchar2(10),            /*资料所有部门                           */
ryemodu     varchar2(10),            /*资料更改者                             */
ryeuser     varchar2(10),            /*资料所有者                             */
ryeorig     varchar2(10),            /*资料建立部门                           */
ryeoriu     varchar2(10),            /*资料建立者                             */
rye04       varchar2(5),
rye05       varchar2(10)             /*所属营运中心                           */
);

alter table rye_file add  constraint rye_pk primary key  (rye01,rye02,rye03) enable validate;
grant select on rye_file to tiptopgp;
grant update on rye_file to tiptopgp;
grant delete on rye_file to tiptopgp;
grant insert on rye_file to tiptopgp;
grant index on rye_file to public;
grant select on rye_file to ods;
