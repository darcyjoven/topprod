/*
================================================================================
檔案代號:xse_file
檔案名稱:促銷公告檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xse_file
(
xse01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销代码*/
xse02       varchar2(30),            /*促销主题                               */
xse03       date DEFAULT sysdate NOT NULL, /*发布日期*/
xse04       date DEFAULT sysdate NOT NULL, /*促销日期起始*/
xse05       date DEFAULT sysdate NOT NULL, /*促销日期截止*/
xse06       varchar2(255),           /*备注                                   */
xse07       varchar2(1) DEFAULT ' ' NOT NULL, /*状态*/
xse99       varchar2(10) DEFAULT ' ' NOT NULL /*经销商*/
);

alter table xse_file add  constraint xse_pk primary key  (xse01) enable validate;
grant select on xse_file to tiptopgp;
grant update on xse_file to tiptopgp;
grant delete on xse_file to tiptopgp;
grant insert on xse_file to tiptopgp;
grant index on xse_file to public;
grant select on xse_file to ods;
