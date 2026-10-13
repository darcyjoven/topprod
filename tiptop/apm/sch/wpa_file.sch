/*
================================================================================
檔案代號:wpa_file
檔案名稱:厂商电子采购设置资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpa_file
(
wpa01       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
wpa02       varchar2(1) DEFAULT 'N' NOT NULL, /*是否为电子采购供应商*/
wpa03       varchar2(10) DEFAULT ' ' NOT NULL,
wpa05       varchar2(5),             /*询价单别                               */
wpa06       varchar2(5),             /*核价单别                               */
wpa07       varchar2(5),             /*采购单别                               */
wpa08       varchar2(5)              /*收货单别                               */
);

alter table wpa_file add  constraint wpa_pk primary key  (wpa01,wpa03) enable validate;
grant select on wpa_file to tiptopgp;
grant update on wpa_file to tiptopgp;
grant delete on wpa_file to tiptopgp;
grant insert on wpa_file to tiptopgp;
grant index on wpa_file to public;
grant select on wpa_file to ods;
