/*
================================================================================
檔案代號:ayb_file
檔案名稱:股东权益分类对应会计科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ayb_file
(
ayb01       varchar2(10) NOT NULL,   /*分类代码                               */
ayb02       varchar2(24) NOT NULL,   /*会计科目                               */
ayb03       varchar2(1),             /*no use                                 */
ayb04       varchar2(255),           /*no use                                 */
ayb05       varchar2(10) DEFAULT ' ' NOT NULL, /*族群代码*/
ayb06       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
ayb07       varchar2(5) DEFAULT ' ' NOT NULL /*帐套*/
);

alter table ayb_file add  constraint ayb_pk primary key  (ayb01,ayb02,ayb05,ayb06,ayb07) enable validate;
grant select on ayb_file to tiptopgp;
grant update on ayb_file to tiptopgp;
grant delete on ayb_file to tiptopgp;
grant insert on ayb_file to tiptopgp;
grant index on ayb_file to public;
grant select on ayb_file to ods;
