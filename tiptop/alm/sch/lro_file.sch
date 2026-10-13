/*
================================================================================
檔案代號:lro_file
檔案名稱:实发券登记记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lro_file
(
lro00       varchar2(10),            /*no use 原门店编号                      */
lro01       varchar2(20) DEFAULT ' ' NOT NULL, /*券发放单号*/
lro02       varchar2(20) DEFAULT ' ' NOT NULL, /*券编号*/
lro03       varchar2(20),            /*券种                                   */
lrolegal    varchar2(10) NOT NULL,   /*所属法人                               */
lroplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lro_file add  constraint lro_pk primary key  (lro01,lro02) enable validate;
grant select on lro_file to tiptopgp;
grant update on lro_file to tiptopgp;
grant delete on lro_file to tiptopgp;
grant insert on lro_file to tiptopgp;
grant index on lro_file to public;
grant select on lro_file to ods;
