/*
================================================================================
檔案代號:imqi_file
檔案名稱:还料明细资料行业别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imqi_file
(
imqi01      varchar2(20) DEFAULT ' ' NOT NULL, /*还料单号*/
imqi02      number(5) DEFAULT '0' NOT NULL, /*项次*/
imqiicd028  varchar2(80),            /*DATECODE                               */
imqiicd029  varchar2(24),            /*母批                                   */
imqilegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
imqiplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table imqi_file add  constraint imqi_pk primary key  (imqi01,imqi02) enable validate;
grant select on imqi_file to tiptopgp;
grant update on imqi_file to tiptopgp;
grant delete on imqi_file to tiptopgp;
grant insert on imqi_file to tiptopgp;
grant index on imqi_file to public;
grant select on imqi_file to ods;
