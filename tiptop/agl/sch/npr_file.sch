/*
================================================================================
檔案代號:npr_file
檔案名稱:子系统各期统计开账
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table npr_file
(
npr00       varchar2(24) NOT NULL,   /*科目编号                               */
npr01       varchar2(10) NOT NULL,   /*对象                                   */
npr02       varchar2(40) NOT NULL,   /*对象简称                               */
npr03       varchar2(10) NOT NULL,   /*部门                                   */
npr04       number(5) NOT NULL,      /*年度                                   */
npr05       number(5) NOT NULL,      /*期别                                   */
npr06f      number(20,6),            /*原币金额                               */
npr06       number(20,6),            /*借方本币金额                           */
npr07f      number(20,6),            /*贷方原币金额                           */
npr07       number(20,6),            /*贷方本币金额                           */
npr08       varchar2(10) NOT NULL,   /*总账营运中心                           */
npr09       varchar2(5) NOT NULL,    /*帐套                                   */
npr10       varchar2(1) NOT NULL,    /*来源                                   */
npr11       varchar2(4) NOT NULL,    /*币种                                   */
nprlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index npr_02 on npr_file (npr01,npr02);
alter table npr_file add  constraint npr_pk primary key  (npr08,npr09,npr00,npr10,npr01,npr02,npr03,npr11,npr04,npr05) enable validate;
grant select on npr_file to tiptopgp;
grant update on npr_file to tiptopgp;
grant delete on npr_file to tiptopgp;
grant insert on npr_file to tiptopgp;
grant index on npr_file to public;
grant select on npr_file to ods;
