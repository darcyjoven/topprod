/*
================================================================================
檔案代號:lla_file
檔案名稱:招商门店参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lla_file
(
lla01       varchar2(1) DEFAULT ' ' NOT NULL, /*日核算尾差1:月首 2:月尾*/
lla02       varchar2(1) DEFAULT ' ' NOT NULL, /*合同日核算是否可更改*/
llalegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
llastore    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
lla03       varchar2(1) DEFAULT ' ' NOT NULL, /*面积小数位数*/
lla04       varchar2(1) DEFAULT ' ' NOT NULL, /*金额小数位数*/
lla05       varchar2(1) DEFAULT ' ' NOT NULL /*账单是否按自然月拆分*/
);

alter table lla_file add  constraint lla_pk primary key  (llastore) enable validate;
grant select on lla_file to tiptopgp;
grant update on lla_file to tiptopgp;
grant delete on lla_file to tiptopgp;
grant insert on lla_file to tiptopgp;
grant index on lla_file to public;
grant select on lla_file to ods;
