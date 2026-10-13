/*
================================================================================
檔案代號:ahc_file
檔案名稱:常用凭证额外摘要档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ahc_file
(
ahc00       varchar2(5) NOT NULL,    /*帐套                                   */
ahc000      varchar2(1) NOT NULL,    /*常用凭证性质                           */
ahc01       varchar2(20) NOT NULL,   /*常用凭证编号                           */
ahc02       number(5) NOT NULL,      /*项次                                   */
ahc03       number(5) NOT NULL,      /*行序                                   */
ahc04       varchar2(80),            /*摘要                                   */
ahclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ahc_file add  constraint ahc_pk primary key  (ahc01,ahc02,ahc03,ahc00,ahc000) enable validate;
grant select on ahc_file to tiptopgp;
grant update on ahc_file to tiptopgp;
grant delete on ahc_file to tiptopgp;
grant insert on ahc_file to tiptopgp;
grant index on ahc_file to public;
grant select on ahc_file to ods;
