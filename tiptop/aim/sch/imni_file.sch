/*
================================================================================
檔案代號:imni_file
檔案名稱:库存调拨单单身行业别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imni_file
(
imni01      varchar2(20) DEFAULT ' ' NOT NULL, /*调拨单号*/
imni02      number(5) DEFAULT '0' NOT NULL, /*项次*/
imniicd028  varchar2(80),            /*DATECODE                               */
imniicd029  varchar2(24),            /*母批                                   */
imnilegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
imniplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table imni_file add  constraint imni_pk primary key  (imni01,imni02) enable validate;
grant select on imni_file to tiptopgp;
grant update on imni_file to tiptopgp;
grant delete on imni_file to tiptopgp;
grant insert on imni_file to tiptopgp;
grant index on imni_file to public;
grant select on imni_file to ods;
