/*
================================================================================
檔案代號:bnn_file
檔案名稱:料件承认申请单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bnn_file
(
bnn01       varchar2(20) DEFAULT ' ' NOT NULL, /*料件承认申请单号*/
bnn02       number(5) NOT NULL,      /*项次                                   */
bnn03       varchar2(40),            /*料件编号                               */
bnn04       varchar2(24),            /*制造商编号                             */
bnn05       varchar2(40),            /*厂商料号                               */
bnn06       varchar2(10),            /*承认文号                               */
bnn07       varchar2(255),           /*備注                                   */
bnn08       varchar2(10),            /*送样编号                               */
bnn09       date,                    /*送样日期                               */
bnn10       date,                    /*承认日期                               */
bnnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bnnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bnn_file add  constraint bnn_pk primary key  (bnn01,bnn02) enable validate;
grant select on bnn_file to tiptopgp;
grant update on bnn_file to tiptopgp;
grant delete on bnn_file to tiptopgp;
grant insert on bnn_file to tiptopgp;
grant index on bnn_file to public;
grant select on bnn_file to ods;
