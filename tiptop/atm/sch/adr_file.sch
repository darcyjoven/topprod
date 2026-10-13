/*
================================================================================
檔案代號:adr_file
檔案名稱:NO USE
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table adr_file
(
adr01       varchar2(10) NOT NULL,   /*客户编号                               */
adr02       varchar2(40) NOT NULL,   /*产品编号                               */
adr03       varchar2(24) NOT NULL,   /*批号                                   */
adr04       number(5) NOT NULL,      /*年度                                   */
adr05       number(5) NOT NULL,      /*期别                                   */
adr06       number(15,3),            /*本期销售                               */
adr07       number(15,3),            /*本期销退                               */
adr08       number(15,3),            /*客户销售                               */
adr09       number(15,3)             /*期末数量                               */
);

alter table adr_file add  constraint adr_pk primary key  (adr01,adr02,adr03,adr04,adr05) enable validate;
grant select on adr_file to tiptopgp;
grant update on adr_file to tiptopgp;
grant delete on adr_file to tiptopgp;
grant insert on adr_file to tiptopgp;
grant index on adr_file to public;
grant select on adr_file to ods;
