/*
================================================================================
檔案代號:axx_file
檔案名稱:合并报表关系人递延项摊销明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table axx_file
(
axx01       varchar2(5) NOT NULL,    /*年度                                   */
axx02       varchar2(5) NOT NULL,    /*期别                                   */
axx03       varchar2(10) NOT NULL,   /*集团代号                               */
axx04       varchar2(5) NOT NULL,    /*项次                                   */
axx05       number(5) NOT NULL,      /*摊销年度                               */
axx06       number(5) NOT NULL,      /*摊销期别                               */
axx07       number(20,6),            /*本期摊销金额                           */
axx08       number(20,6),            /*本期摊销合并币种金额                   */
axx031      varchar2(10) NOT NULL,   /*母公司                                 */
axxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table axx_file add  constraint axx_pk primary key  (axx01,axx02,axx03,axx031,axx04,axx05,axx06) enable validate;
grant select on axx_file to tiptopgp;
grant update on axx_file to tiptopgp;
grant delete on axx_file to tiptopgp;
grant insert on axx_file to tiptopgp;
grant index on axx_file to public;
grant select on axx_file to ods;
