/*
================================================================================
檔案代號:lof_file
檔案名稱:合同变更其他资料品牌资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lof_file
(
lof01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
lof02       varchar2(20) DEFAULT ' ' NOT NULL, /*合同版本号*/
lof03       varchar2(10) DEFAULT ' ' NOT NULL, /*品牌编号*/
loflegal    varchar2(10) NOT NULL,   /*所属法人                               */
lofplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lof_file add  constraint lof_pk primary key  (lof01,lof02,lof03) enable validate;
grant select on lof_file to tiptopgp;
grant update on lof_file to tiptopgp;
grant delete on lof_file to tiptopgp;
grant insert on lof_file to tiptopgp;
grant index on lof_file to public;
grant select on lof_file to ods;
