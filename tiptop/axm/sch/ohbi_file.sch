/*
================================================================================
檔案代號:ohbi_file
檔案名稱:销退单身行业别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ohbi_file
(
ohbi01      varchar2(20) DEFAULT ' ' NOT NULL, /*销退单号*/
ohbi03      number(5) DEFAULT '0' NOT NULL, /*项次*/
ohbiicd028  varchar2(80),            /*DATECODE                               */
ohbiicd029  varchar2(24),            /*母批                                   */
ohbilegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ohbiplant   varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
ohbislk01   varchar2(40),            /*款号料件编号                           */
ohbislk02   number(5)                /*款號項次                               */
);

alter table ohbi_file add  constraint ohbi_pk primary key  (ohbi01,ohbi03) enable validate;
grant select on ohbi_file to tiptopgp;
grant update on ohbi_file to tiptopgp;
grant delete on ohbi_file to tiptopgp;
grant insert on ohbi_file to tiptopgp;
grant index on ohbi_file to public;
grant select on ohbi_file to ods;
