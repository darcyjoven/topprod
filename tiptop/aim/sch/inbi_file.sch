/*
================================================================================
檔案代號:inbi_file
檔案名稱:库存异动单据单身行业别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table inbi_file
(
inbi01      varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
inbi03      number(5) DEFAULT '0' NOT NULL, /*项次*/
inbiicd028  varchar2(80),            /*DATECODE                               */
inbiicd029  varchar2(24),            /*母批                                   */
inbilegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
inbiplant   varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
inbislk01   varchar2(40),            /*母料件款号                             */
inbislk02   number(5)                /*母料件款号项次                         */
);

alter table inbi_file add  constraint inbi_pk primary key  (inbi01,inbi03) enable validate;
grant select on inbi_file to tiptopgp;
grant update on inbi_file to tiptopgp;
grant delete on inbi_file to tiptopgp;
grant insert on inbi_file to tiptopgp;
grant index on inbi_file to public;
grant select on inbi_file to ods;
