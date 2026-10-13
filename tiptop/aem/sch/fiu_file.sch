/*
================================================================================
檔案代號:fiu_file
檔案名稱:设备保养周期档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fiu_file
(
fiu01       varchar2(2) NOT NULL,    /*保养周期编号                           */
fiu02       varchar2(80),            /*说明                                   */
fiuacti     varchar2(1),             /*资料有效码                             */
fiuuser     varchar2(10),            /*资料所有者                             */
fiugrup     varchar2(10),            /*资料所有部门                           */
fiumodu     varchar2(10),            /*最后更改人员                           */
fiudate     date,                    /*最后更改日期                           */
fiuorig     varchar2(10),            /*资料建立部门                           */
fiuoriu     varchar2(10)             /*资料建立者                             */
);

alter table fiu_file add  constraint fiu_pk primary key  (fiu01) enable validate;
grant select on fiu_file to tiptopgp;
grant update on fiu_file to tiptopgp;
grant delete on fiu_file to tiptopgp;
grant insert on fiu_file to tiptopgp;
grant index on fiu_file to public;
grant select on fiu_file to ods;
