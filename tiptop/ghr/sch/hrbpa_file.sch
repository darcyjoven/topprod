/*
================================================================================
檔案代號:hrbpa_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbpa_file
(
hrbpa01     number(5) NOT NULL,      /*序号                                   */
hrbpa02     varchar2(20),            /*班次/班组编号                          */
hrbpa03     varchar2(60),            /*班次/班组名称                          */
hrbpa04     varchar2(255),           /*备注                                   */
hrbpa05     varchar2(20) NOT NULL    /*班次轮转编号                           */
);

alter table hrbpa_file add  constraint tpc_hrbpa_pk primary key  (hrbpa01,hrbpa05) enable validate;
grant select on hrbpa_file to tiptopgp;
grant update on hrbpa_file to tiptopgp;
grant delete on hrbpa_file to tiptopgp;
grant insert on hrbpa_file to tiptopgp;
grant index on hrbpa_file to public;
grant select on hrbpa_file to ods;
