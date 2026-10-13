/*
================================================================================
檔案代號:ryo_file
檔案名稱:POS使用者营运中心权限资料档
檔案目的:
上游檔案:ryi_file
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryo_file
(
ryo01       varchar2(10) DEFAULT ' ' NOT NULL,
ryo02       varchar2(10) DEFAULT ' ' NOT NULL, /*使用营运中心编号*/
ryoacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table ryo_file add  constraint ryo_pk primary key  (ryo01,ryo02) enable validate;
grant select on ryo_file to tiptopgp;
grant update on ryo_file to tiptopgp;
grant delete on ryo_file to tiptopgp;
grant insert on ryo_file to tiptopgp;
grant index on ryo_file to public;
grant select on ryo_file to ods;
