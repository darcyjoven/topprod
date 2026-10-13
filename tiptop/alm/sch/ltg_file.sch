/*
================================================================================
檔案代號:ltg_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltg_file
(
ltg01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号*/
ltg02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
ltg03       varchar2(20) DEFAULT ' ' NOT NULL, /*生效单据号*/
ltglegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltgplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table ltg_file add  constraint ltg_pk primary key  (ltg01,ltg02,ltg03) enable validate;
grant select on ltg_file to tiptopgp;
grant update on ltg_file to tiptopgp;
grant delete on ltg_file to tiptopgp;
grant insert on ltg_file to tiptopgp;
grant index on ltg_file to public;
grant select on ltg_file to ods;
