/*
================================================================================
檔案代號:idx_file
檔案名稱:ICD料件批号期间/月统计档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table idx_file
(
idx01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
idx02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
idx03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
idx04       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
idx05       number(5) DEFAULT '0' NOT NULL, /*年度*/
idx06       number(5) DEFAULT '0' NOT NULL, /*期别*/
idx081      number(15,3),            /*本期入库统计量                         */
idx082      number(15,3),            /*本期销售统计量                         */
idx083      number(15,3),            /*本期领用统计量                         */
idx084      number(15,3),            /*本期调拨统计量                         */
idx085      number(15,3),            /*本期调整统计量                         */
idx09       number(15,3),            /*期末数量                               */
idx10       varchar2(3) DEFAULT ' ' NOT NULL, /*刻号*/
idx11       varchar2(5) DEFAULT ' ' NOT NULL, /*BIN*/
idxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
idxplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table idx_file add  constraint idx_pk primary key  (idx01,idx02,idx03,idx04,idx05,idx06,idx10,idx11) enable validate;
grant select on idx_file to tiptopgp;
grant update on idx_file to tiptopgp;
grant delete on idx_file to tiptopgp;
grant insert on idx_file to tiptopgp;
grant index on idx_file to public;
grant select on idx_file to ods;
