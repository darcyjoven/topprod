/*
================================================================================
檔案代號:gil_file
檔案名稱:现金流量表活动科目
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gil_file
(
gil01       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別 1.營業 2.投資 3.理財              */
gil02       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
gil00       varchar2(5) NOT NULL     /*帐套                                   */
);

alter table gil_file add  constraint gil_pk primary key  (gil00,gil01,gil02) enable validate;
grant select on gil_file to tiptopgp;
grant update on gil_file to tiptopgp;
grant delete on gil_file to tiptopgp;
grant insert on gil_file to tiptopgp;
grant index on gil_file to public;
grant select on gil_file to ods;
