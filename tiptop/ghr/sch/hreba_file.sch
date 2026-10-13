/*
================================================================================
檔案代號:hreba_file
檔案名稱:薪酬制定预算管理
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hreba_file
(
hreba00     varchar2(20) NOT NULL,   /*预算年度                               */
hreba01     varchar2(20) NOT NULL,   /*预算类别                               */
hreba02     varchar2(20) NOT NULL,   /*期别                                   */
hreba03     number(15,2),            /*预算金额                               */
hreba04     number(15,2),            /*追加预算额                             */
hreba05     number(15,2),            /*消减预算额                             */
hreba06     number(15,2)             /*已发生额                               */
);

alter table hreba_file add  constraint hreba_pk primary key  (hreba00,hreba01,hreba02) enable validate;
grant select on hreba_file to tiptopgp;
grant update on hreba_file to tiptopgp;
grant delete on hreba_file to tiptopgp;
grant insert on hreba_file to tiptopgp;
grant index on hreba_file to public;
grant select on hreba_file to ods;
