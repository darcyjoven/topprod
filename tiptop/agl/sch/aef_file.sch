/*
================================================================================
檔案代號:aef_file
檔案名稱:项目余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aef_file
(
aef00       varchar2(5) NOT NULL,    /*帐套                                   */
aef01       varchar2(24) NOT NULL,   /*科目编号                               */
aef02       varchar2(10) NOT NULL,   /*项目编号                               */
aef03       number(5) NOT NULL,      /*会计年度                               */
aef04       number(5) NOT NULL,      /*期别                                   */
aef05       number(20,6),            /*借方总金额                             */
aef06       number(20,6),            /*贷方总金额                             */
aef07       number(5),               /*贷方总笔数                             */
aef08       number(5),               /*贷方总笔数                             */
aeflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table aef_file add  constraint aef_pk primary key  (aef01,aef02,aef03,aef04,aef00) enable validate;
grant select on aef_file to tiptopgp;
grant update on aef_file to tiptopgp;
grant delete on aef_file to tiptopgp;
grant insert on aef_file to tiptopgp;
grant index on aef_file to public;
grant select on aef_file to ods;
