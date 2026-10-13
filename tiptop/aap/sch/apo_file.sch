/*
================================================================================
檔案代號:apo_file
檔案名稱:AAP-留置原因档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table apo_file
(
apo01       varchar2(10) NOT NULL,   /*留置原因编号                           */
                                     /*留置原因編號                           */
apo02       varchar2(80),            /*留置原因                               */
apoacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
apouser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
apogrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
apomodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
apodate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
apoorig     varchar2(10),            /*资料建立部门                           */
apooriu     varchar2(10)             /*资料建立者                             */
);

alter table apo_file add  constraint apo_pk primary key  (apo01) enable validate;
grant select on apo_file to tiptopgp;
grant update on apo_file to tiptopgp;
grant delete on apo_file to tiptopgp;
grant insert on apo_file to tiptopgp;
grant index on apo_file to public;
grant select on apo_file to ods;
