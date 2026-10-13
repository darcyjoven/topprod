/*
================================================================================
檔案代號:pnni_file
檔案名稱:采购分配底稿档
檔案目的:采购分配底稿档(行业别架构)
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnni_file
(
pnni01      varchar2(20) DEFAULT ' ' NOT NULL, /*请购单号*/
pnni02      number(10) DEFAULT '0' NOT NULL, /*请购项次*/
pnni03      varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
pnni05      varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
pnni06      varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
pnnislk01   varchar2(20),            /*制单号                                 */
pnniplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
pnnilegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pnni_file add  constraint pnni_pk primary key  (pnni01,pnni02,pnni03,pnni05,pnni06) enable validate;
grant select on pnni_file to tiptopgp;
grant update on pnni_file to tiptopgp;
grant delete on pnni_file to tiptopgp;
grant insert on pnni_file to tiptopgp;
grant index on pnni_file to public;
grant select on pnni_file to ods;
