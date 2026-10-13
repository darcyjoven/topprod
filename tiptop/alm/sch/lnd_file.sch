/*
================================================================================
檔案代號:lnd_file
檔案名稱:潜在商户经营信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnd_file
(
lnd00       varchar2(10),            /*来源门店编号                           */
lnd01       varchar2(20) DEFAULT ' ' NOT NULL, /*潜在商户单号*/
lnd02       varchar2(20) DEFAULT ' ' NOT NULL, /*证件编号*/
lnd03       varchar2(20) DEFAULT ' ' NOT NULL, /*证件号码*/
lnd04       varchar2(40),            /*经营人                                 */
lnd05       date,                    /*有效期起日                             */
lnd06       date                     /*有效期止日                             */
);

alter table lnd_file add  constraint lnd_pk primary key  (lnd01,lnd02,lnd03) enable validate;
grant select on lnd_file to tiptopgp;
grant update on lnd_file to tiptopgp;
grant delete on lnd_file to tiptopgp;
grant insert on lnd_file to tiptopgp;
grant index on lnd_file to public;
grant select on lnd_file to ods;
