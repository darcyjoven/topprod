/*
================================================================================
檔案代號:aed_file
檔案名稱:科目核算项冲账余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aed_file
(
aed00       varchar2(5) NOT NULL,    /*帐套                                   */
aed01       varchar2(24) NOT NULL,   /*科目编号                               */
aed011      varchar2(2) NOT NULL,    /*核算项顺序                             */
aed02       varchar2(30) NOT NULL,   /*核算项值                               */
aed03       number(5) NOT NULL,      /*会计年度                               */
aed04       number(5) NOT NULL,      /*期别                                   */
aed05       number(20,6),            /*借方总金额                             */
aed06       number(20,6),            /*贷方总金额                             */
aed07       number(5),               /*借方总笔数                             */
aed08       number(5),               /*贷方总笔数                             */
aed012      varchar2(10),            /*核算项类型编号                         */
                                     /*#FUN-5C0015                            */
aedlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table aed_file add  constraint aed_pk primary key  (aed01,aed02,aed03,aed04,aed00,aed011) enable validate;
grant select on aed_file to tiptopgp;
grant update on aed_file to tiptopgp;
grant delete on aed_file to tiptopgp;
grant insert on aed_file to tiptopgp;
grant index on aed_file to public;
grant select on aed_file to ods;
