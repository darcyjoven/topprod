/*
================================================================================
檔案代號:aao_file
檔案名稱:部门科目余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aao_file
(
aao00       varchar2(5) NOT NULL,    /*帐套                                   */
aao01       varchar2(24) NOT NULL,   /*科目编号                               */
aao02       varchar2(10) NOT NULL,   /*部门编号                               */
aao03       number(5) NOT NULL,      /*会计年度                               */
aao04       number(5) NOT NULL,      /*期别                                   */
aao05       number(20,6),            /*借方余额                               */
aao06       number(20,6),            /*贷方余额                               */
aao07       number(15,3),            /*借方笔数                               */
aao08       number(15,3),            /*贷方笔数                               */
aaolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table aao_file add  constraint aao_pk primary key  (aao01,aao02,aao03,aao04,aao00) enable validate;
grant select on aao_file to tiptopgp;
grant update on aao_file to tiptopgp;
grant delete on aao_file to tiptopgp;
grant insert on aao_file to tiptopgp;
grant index on aao_file to public;
grant select on aao_file to ods;
