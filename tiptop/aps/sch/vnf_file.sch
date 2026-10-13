/*
================================================================================
檔案代號:vnf_file
檔案名稱:aps 製令外包維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vnf_file
(
vnf01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vnf03       number(1),               /*外包类型                               */
vnf07       number(1),               /*是否已排程                             */
vnflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vnfplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vnf_file add  constraint vnf_pk primary key  (vnf01) enable validate;
grant select on vnf_file to tiptopgp;
grant update on vnf_file to tiptopgp;
grant delete on vnf_file to tiptopgp;
grant insert on vnf_file to tiptopgp;
grant index on vnf_file to public;
grant select on vnf_file to ods;
