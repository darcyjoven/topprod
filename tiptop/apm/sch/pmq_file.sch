/*
================================================================================
檔案代號:pmq_file
檔案名稱:厂商料号品名规格额外说明资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmq_file
(
pmq01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
pmq02       varchar2(10) NOT NULL,   /*供应厂商编号                           */
                                     /*供應廠商編號                           */
pmq03       varchar2(40),            /*厂商料件编号                           */
                                     /*廠商料件編號                           */
pmq04       number(5) NOT NULL,      /*行序                                   */
pmq05       varchar2(255)            /*厂商料号品名规格额外说明               */
                                     /*廠商料號品名規格額外說明               */
);

alter table pmq_file add  constraint pmq_pk primary key  (pmq01,pmq02,pmq04) enable validate;
grant select on pmq_file to tiptopgp;
grant update on pmq_file to tiptopgp;
grant delete on pmq_file to tiptopgp;
grant insert on pmq_file to tiptopgp;
grant index on pmq_file to public;
grant select on pmq_file to ods;
