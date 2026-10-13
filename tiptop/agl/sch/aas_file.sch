/*
================================================================================
檔案代號:aas_file
檔案名稱:会计科目每日余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aas_file
(
aas00       varchar2(5) NOT NULL,    /*帐套编号                               */
aas01       varchar2(24) NOT NULL,   /*科目编号                               */
aas02       date NOT NULL,           /*日期                                   */
aas04       number(20,6),            /*借方金额                               */
aas05       number(20,6),            /*贷方金额                               */
aas06       number(10),              /*借方笔数                               */
aas07       number(10),              /*贷方笔数                               */
aaslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table aas_file add  constraint aas_pk primary key  (aas01,aas02,aas00) enable validate;
grant select on aas_file to tiptopgp;
grant update on aas_file to tiptopgp;
grant delete on aas_file to tiptopgp;
grant insert on aas_file to tiptopgp;
grant index on aas_file to public;
grant select on aas_file to ods;
