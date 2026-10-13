/*
================================================================================
檔案代號:odn_file
檔案名稱:订货会手册单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odn_file
(
odn01       varchar2(10) DEFAULT ' ' NOT NULL, /*訂貨會編號*/
odn02       varchar2(10) DEFAULT ' ' NOT NULL, /*手册编号*/
odn03       number(5) DEFAULT '0' NOT NULL, /*页码*/
odn04       varchar2(10) DEFAULT ' ' NOT NULL, /*行数*/
odn05       varchar2(40),            /*款号                                   */
odn06       varchar2(1) DEFAULT 'N' NOT NULL, /*必订货品否*/
odn07       varchar2(1) DEFAULT 'N' NOT NULL, /*主推货品否*/
odn08       number(15,3) DEFAULT '0' NOT NULL, /*最低限额*/
odn09       number(15,3) DEFAULT '0' NOT NULL /*最小起订量*/
);

alter table odn_file add  constraint odn_pk primary key  (odn01,odn02,odn03,odn04) enable validate;
grant select on odn_file to tiptopgp;
grant update on odn_file to tiptopgp;
grant delete on odn_file to tiptopgp;
grant insert on odn_file to tiptopgp;
grant index on odn_file to public;
grant select on odn_file to ods;
