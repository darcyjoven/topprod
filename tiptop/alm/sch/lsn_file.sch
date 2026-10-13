/*
================================================================================
檔案代號:lsn_file
檔案名稱:儲值卡金額異動檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsn_file
(
lsn01       varchar2(30) DEFAULT ' ' NOT NULL, /*卡号*/
lsn02       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
lsn03       varchar2(20) DEFAULT ' ' NOT NULL, /*交易单号*/
lsn04       number(20,2) DEFAULT '0' NOT NULL, /*本次异动金额*/
lsn05       date,                    /*异动日期                               */
lsn06       date,                    /*金额有效期                             */
lsn07       number(6,2) DEFAULT '0' NOT NULL, /*折扣率*/
lsn08       varchar2(10) DEFAULT ' ',/*no use                                 */
lsnlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lsnplant    varchar2(10) DEFAULT ' ',/*no use                                 */
lsn09       number(20,6) DEFAULT '0' NOT NULL,
lsn10       varchar2(1) DEFAULT ' ' NOT NULL, /*来源类型*/
lsnstore    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lsn_file add  constraint lsn_pk primary key  (lsn01,lsn02,lsn03,lsn10,lsnstore) enable validate;
grant select on lsn_file to tiptopgp;
grant update on lsn_file to tiptopgp;
grant delete on lsn_file to tiptopgp;
grant insert on lsn_file to tiptopgp;
grant index on lsn_file to public;
grant select on lsn_file to ods;
