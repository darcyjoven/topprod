/*
================================================================================
檔案代號:ruh_file
檔案名稱:产品策略变更税别明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruh_file
(
ruh01       varchar2(20) DEFAULT ' ' NOT NULL, /*策略变更单号*/
ruh02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ruh03       number(5) DEFAULT '0' NOT NULL, /*序号*/
ruh04       varchar2(4),             /*税种                                   */
ruh05       varchar2(1) DEFAULT '2' NOT NULL, /*进/销项*/
ruh06       number(20,6) DEFAULT '0' NOT NULL, /*固定税额*/
ruhlegal    varchar2(10),            /*所属法人                               */
ruhplant    varchar2(10)             /*所属工厂                               */
);

alter table ruh_file add  constraint ruh_pk primary key  (ruh01,ruh02,ruh03) enable validate;
grant select on ruh_file to tiptopgp;
grant update on ruh_file to tiptopgp;
grant delete on ruh_file to tiptopgp;
grant insert on ruh_file to tiptopgp;
grant index on ruh_file to public;
grant select on ruh_file to ods;
