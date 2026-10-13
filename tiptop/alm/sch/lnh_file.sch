/*
================================================================================
檔案代號:lnh_file
檔案名稱:正式商戶狀態信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnh_file
(
lnh00       varchar2(10),            /*来源门店编号                           */
lnh01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lnh02       varchar2(20),            /*版本号                                 */
lnh03       varchar2(10),            /*no use                                 */
lnh04       varchar2(1) DEFAULT ' ' NOT NULL, /*商户初始状态*/
lnh05       varchar2(1) DEFAULT ' ' NOT NULL, /*希望变更状态*/
lnh06       varchar2(1) DEFAULT ' ' NOT NULL, /*确认结果*/
lnh07       varchar2(1) DEFAULT ' ' NOT NULL, /*商户状态*/
lnhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnhstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lnh_file add  constraint lnh_pk primary key  (lnh01,lnhstore) enable validate;
grant select on lnh_file to tiptopgp;
grant update on lnh_file to tiptopgp;
grant delete on lnh_file to tiptopgp;
grant insert on lnh_file to tiptopgp;
grant index on lnh_file to public;
grant select on lnh_file to ods;
