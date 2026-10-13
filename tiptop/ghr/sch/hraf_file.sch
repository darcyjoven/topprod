/*
================================================================================
檔案代號:hraf_file
檔案名稱:区域资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hraf_file
(
hraf01      varchar2(10) NOT NULL,   /*区域编码                               */
hraf02      varchar2(50),            /*区域名称                               */
hraf03      varchar2(50),            /*区域简称                               */
hraf04      varchar2(50),            /*区域主管                               */
hraf05      varchar2(255),           /*掌管范围                               */
hraf06      varchar2(255),           /*备注                                   */
hrafuser    varchar2(10),            /*资料所有者                             */
hrafgrup    varchar2(10),            /*资料所有群                             */
hrafmodu    varchar2(10),            /*资料修改者                             */
hrafdate    date,                    /*最近修改日                             */
hraforig    varchar2(10),            /*资料建立者                             */
hraforiu    varchar2(10)             /*资料建立部门                           */
);

alter table hraf_file add  constraint tpc_hraf_pk primary key  (hraf01) enable validate;
grant select on hraf_file to tiptopgp;
grant update on hraf_file to tiptopgp;
grant delete on hraf_file to tiptopgp;
grant insert on hraf_file to tiptopgp;
grant index on hraf_file to public;
grant select on hraf_file to ods;
