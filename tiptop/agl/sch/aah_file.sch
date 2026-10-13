/*
================================================================================
檔案代號:aah_file
檔案名稱:会计科目各期余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aah_file
(
aah00       varchar2(5) NOT NULL,    /*帐套编号                               */
aah01       varchar2(24) NOT NULL,   /*科目编号                               */
aah02       number(5) NOT NULL,      /*会计年度                               */
aah03       number(5) NOT NULL,      /*期别                                   */
aah04       number(20,6) NOT NULL,   /*借方金额                               */
aah05       number(20,6) NOT NULL,   /*贷方金额                               */
aah06       number(10),              /*借方笔数                               */
aah07       number(10),              /*贷方笔数                               */
aahlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table aah_file add  constraint aah_pk primary key  (aah01,aah02,aah03,aah00) enable validate;
grant select on aah_file to tiptopgp;
grant update on aah_file to tiptopgp;
grant delete on aah_file to tiptopgp;
grant insert on aah_file to tiptopgp;
grant index on aah_file to public;
grant select on aah_file to ods;
