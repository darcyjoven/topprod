/*
================================================================================
檔案代號:lsm_file
檔案名稱:銷售及積分異動檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsm_file
(
lsm01       varchar2(30) DEFAULT ' ' NOT NULL, /*卡号*/
lsm02       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
lsm03       varchar2(20) DEFAULT ' ' NOT NULL, /*交易单号*/
lsm04       number(20) DEFAULT '0' NOT NULL, /*本次异动积分*/
lsm05       date DEFAULT sysdate NOT NULL, /*异动日期*/
lsm06       date,                    /*积分有效期                             */
lsm07       varchar2(10) DEFAULT ' ',/*no ues                                 */
lsm08       number(20,6) DEFAULT '0' NOT NULL, /*消费金额*/
lsmlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lsmplant    varchar2(10) DEFAULT ' ',/*no use                                 */
lsm09       number(20) DEFAULT '0' NOT NULL, /*原卡累计消费次数*/
lsm10       number(20,2) DEFAULT '0' NOT NULL, /*原卡累计消费金额*/
lsm11       number(20) DEFAULT '0' NOT NULL, /*原卡累计消费积分*/
lsm12       number(20) DEFAULT '0' NOT NULL, /*原卡剩余积分*/
lsm13       number(20) DEFAULT '0' NOT NULL, /*原卡已兑换积分*/
lsm14       date,                    /*原卡最后消费日                         */
lsm15       varchar2(1) DEFAULT ' ' NOT NULL, /*来源类型*/
lsmstore    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lsm_file add  constraint lsm_pk primary key  (lsm01,lsm02,lsm03,lsm05,lsm15,lsmstore) enable validate;
grant select on lsm_file to tiptopgp;
grant update on lsm_file to tiptopgp;
grant delete on lsm_file to tiptopgp;
grant insert on lsm_file to tiptopgp;
grant index on lsm_file to public;
grant select on lsm_file to ods;
