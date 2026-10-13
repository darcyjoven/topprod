/*
================================================================================
檔案代號:fis_file
檔案名稱:设备检验项目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fis_file
(
fis01       varchar2(10) NOT NULL,   /*检验项目编号                           */
fis02       varchar2(80),            /*内容                                   */
fisacti     varchar2(1),             /*资料有效码                             */
fisuser     varchar2(10),            /*资料所有者                             */
fisgrup     varchar2(10),            /*资料所有部门                           */
fismodu     varchar2(10),            /*最后更改人员                           */
fisdate     date,                    /*最后更改日期                           */
fisorig     varchar2(10),            /*资料建立部门                           */
fisoriu     varchar2(10)             /*资料建立者                             */
);

alter table fis_file add  constraint fis_pk primary key  (fis01) enable validate;
grant select on fis_file to tiptopgp;
grant update on fis_file to tiptopgp;
grant delete on fis_file to tiptopgp;
grant insert on fis_file to tiptopgp;
grant index on fis_file to public;
grant select on fis_file to ods;
