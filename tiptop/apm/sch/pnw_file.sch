/*
================================================================================
檔案代號:pnw_file
檔案名稱:调拨流程资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnw_file
(
pnw01       varchar2(10) NOT NULL,   /*采购中心代码                           */
pnw02       varchar2(10) NOT NULL,   /*拨出营运中心                           */
pnw03       varchar2(10) NOT NULL,   /*拨入营运中心                           */
pnw04       varchar2(5),             /*缺省采购单别                           */
pnw05       varchar2(8),             /*缺省调拨流程                           */
pnw06       number(5),               /*调拨运输天数                           */
pnwacti     varchar2(1),             /*资料有效码                             */
pnwuser     varchar2(10),            /*资料所有者                             */
pnwgrup     varchar2(10),            /*资料所有群                             */
pnwmodu     varchar2(10),            /*资料更改者                             */
pnwdate     date,                    /*最近更改日                             */
pnworig     varchar2(10),            /*资料建立部门                           */
pnworiu     varchar2(10)             /*资料建立者                             */
);

alter table pnw_file add  constraint pnw_pk primary key  (pnw01,pnw02,pnw03) enable validate;
grant select on pnw_file to tiptopgp;
grant update on pnw_file to tiptopgp;
grant delete on pnw_file to tiptopgp;
grant insert on pnw_file to tiptopgp;
grant index on pnw_file to public;
grant select on pnw_file to ods;
