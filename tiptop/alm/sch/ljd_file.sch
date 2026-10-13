/*
================================================================================
檔案代號:ljd_file
檔案名稱:商户合作情况单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljd_file
(
ljd01       varchar2(20) DEFAULT ' ' NOT NULL, /*申请单号*/
ljd02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljd03       varchar2(20),            /*合约编号                               */
ljd04       varchar2(20),            /*摊位编号                               */
ljd05       varchar2(200),           /*門牌號                                 */
ljd06       date,                    /*租赁期限起日                           */
ljd07       date,                    /*租赁期限止日                           */
ljd08       varchar2(10),            /*经营小类                               */
ljdlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljdplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljd_file add  constraint ljd_pk primary key  (ljd01,ljd02) enable validate;
grant select on ljd_file to tiptopgp;
grant update on ljd_file to tiptopgp;
grant delete on ljd_file to tiptopgp;
grant insert on ljd_file to tiptopgp;
grant index on ljd_file to public;
grant select on ljd_file to ods;
