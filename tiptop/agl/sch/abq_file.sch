/*
================================================================================
檔案代號:abq_file
檔案名稱:財務指標公式設置維護檔
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table abq_file
(
abq00       varchar2(5) DEFAULT ' ' NOT NULL, /*帳套*/
abq01       varchar2(6) NOT NULL,    /*財務分析編號                           */
abq02       varchar2(255),           /*財務分析名稱                           */
abq03       number(9,4) DEFAULT '0' NOT NULL, /*序號*/
abq04       number(5),               /*項次                                   */
abq05       varchar2(1) DEFAULT ' ' NOT NULL, /*數據來源*/
abq06       varchar2(255),           /*指標名稱                               */
abq07       varchar2(255),           /*公式                                   */
abq08       varchar2(255),           /*指標說明                               */
abq09       varchar2(1) DEFAULT ' ' NOT NULL, /*數據格式*/
abq10       number(5),               /*保留位數                               */
abq11       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
abq12       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
abq13       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
abq14       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
abq15       number(20,6) DEFAULT '0' NOT NULL, /*優秀值*/
abq16       number(20,6) DEFAULT '0' NOT NULL, /*良好值*/
abq17       number(20,6) DEFAULT '0' NOT NULL, /*平均值*/
abq18       number(20,6) DEFAULT '0' NOT NULL, /*較低值*/
abq19       number(20,6) DEFAULT '0' NOT NULL, /*較差值*/
abq20       number(20,6) DEFAULT '0' NOT NULL, /*No Use*/
abq21       number(20,6) DEFAULT '0' NOT NULL, /*No Use*/
abq22       number(20,6) DEFAULT '0' NOT NULL, /*No Use*/
abq23       number(20,6) DEFAULT '0' NOT NULL, /*No Use*/
abq24       number(20,6) DEFAULT '0' NOT NULL, /*No Use*/
abq25       number(20,6) DEFAULT '0' NOT NULL /*No Use*/
);

create unique index abq_01 on abq_file (abq00,abq01,abq03);
alter table abq_file add  constraint abq_pk primary key  (abq00,abq01,abq03) enable validate;
grant select on abq_file to tiptopgp;
grant update on abq_file to tiptopgp;
grant delete on abq_file to tiptopgp;
grant insert on abq_file to tiptopgp;
grant index on abq_file to public;
grant select on abq_file to ods;
