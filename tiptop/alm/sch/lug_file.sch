/*
================================================================================
檔案代號:lug_file
檔案名稱:正式商户经营信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lug_file
(
lug00       varchar2(10),            /*来源门店编号                           */
lug01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lug02       varchar2(20) DEFAULT ' ' NOT NULL, /*版本号*/
lug03       varchar2(20) DEFAULT ' ' NOT NULL, /*证件编号*/
lug04       varchar2(20) DEFAULT ' ' NOT NULL, /*证件号码*/
lug05       varchar2(40),            /*经营人                                 */
lug06       date,                    /*有效期起日                             */
lug07       date                     /*有效期止日                             */
);

alter table lug_file add  constraint lug_pk primary key  (lug01,lug02,lug03,lug04) enable validate;
grant select on lug_file to tiptopgp;
grant update on lug_file to tiptopgp;
grant delete on lug_file to tiptopgp;
grant insert on lug_file to tiptopgp;
grant index on lug_file to public;
grant select on lug_file to ods;
