/*
================================================================================
檔案代號:impi_file
檔案名稱:借料资料单身行业别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table impi_file
(
impi01      varchar2(20) DEFAULT ' ' NOT NULL, /*借料单号*/
impi02      number(5) DEFAULT '0' NOT NULL, /*项次*/
impiicd028  varchar2(80),            /*DATECODE                               */
impiicd029  varchar2(24),            /*母批                                   */
impilegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
impiplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table impi_file add  constraint impi_pk primary key  (impi01,impi02) enable validate;
grant select on impi_file to tiptopgp;
grant update on impi_file to tiptopgp;
grant delete on impi_file to tiptopgp;
grant insert on impi_file to tiptopgp;
grant index on impi_file to public;
grant select on impi_file to ods;
