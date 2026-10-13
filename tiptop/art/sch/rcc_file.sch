/*
================================================================================
檔案代號:rcc_file
檔案名稱:专柜抽成资料第二单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rcc_file
(
rcc01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
rcc02       date DEFAULT sysdate NOT NULL, /*生效日期*/
rcc03       date DEFAULT sysdate NOT NULL, /*失效日期*/
rcc04       number(5) DEFAULT '0' NOT NULL, /*项次*/
rcc05       number(5) DEFAULT '0' NOT NULL, /*序号*/
rcc06       varchar2(10),            /*产品分群编号                           */
rccacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table rcc_file add  constraint rcc_pk primary key  (rcc01,rcc02,rcc03,rcc04,rcc05) enable validate;
grant select on rcc_file to tiptopgp;
grant update on rcc_file to tiptopgp;
grant delete on rcc_file to tiptopgp;
grant insert on rcc_file to tiptopgp;
grant index on rcc_file to public;
grant select on rcc_file to ods;
