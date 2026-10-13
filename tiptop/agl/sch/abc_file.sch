/*
================================================================================
檔案代號:abc_file
檔案名稱:会计凭证额外摘要档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table abc_file
(
abc00       varchar2(5) NOT NULL,    /*帐套                                   */
abc01       varchar2(20) NOT NULL,   /*凭证编号                               */
abc02       number(5) NOT NULL,      /*项次                                   */
abc03       number(5) NOT NULL,      /*行序                                   */
abc04       varchar2(80),            /*摘要                                   */
abclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table abc_file add  constraint abc_pk primary key  (abc01,abc02,abc03,abc00) enable validate;
grant select on abc_file to tiptopgp;
grant update on abc_file to tiptopgp;
grant delete on abc_file to tiptopgp;
grant insert on abc_file to tiptopgp;
grant index on abc_file to public;
grant select on abc_file to ods;
