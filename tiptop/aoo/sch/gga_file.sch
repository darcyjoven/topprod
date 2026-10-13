/*
================================================================================
檔案代號:gga_file
檔案名稱:程序自动执行维护单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gga_file
(
gga01       varchar2(10) DEFAULT ' ' NOT NULL, /*流程编号*/
gga02       varchar2(255),           /*流程简称                               */
gga03       varchar2(255),           /*说明                                   */
ggaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ggadate     date,                    /*最近更改日                             */
ggagrup     varchar2(10),            /*资料所有群                             */
ggamodu     varchar2(10),            /*资料更改者                             */
ggaorig     varchar2(10),            /*资料建立部门                           */
ggaoriu     varchar2(10),            /*资料建立者                             */
ggauser     varchar2(10)             /*资料所有者                             */
);

alter table gga_file add  constraint gga_pk primary key  (gga01) enable validate;
grant select on gga_file to tiptopgp;
grant update on gga_file to tiptopgp;
grant delete on gga_file to tiptopgp;
grant insert on gga_file to tiptopgp;
grant index on gga_file to public;
grant select on gga_file to ods;
