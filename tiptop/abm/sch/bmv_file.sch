/*
================================================================================
檔案代號:bmv_file
檔案名稱:固定属性资料档
檔案目的:单档多栏
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmv_file
(
bmv01       varchar2(40) DEFAULT ' ' NOT NULL, /*bom主件款式料号*/
bmv02       varchar2(40) DEFAULT ' ' NOT NULL, /*bom组件款式料号*/
bmv03       varchar2(20) DEFAULT ' ' NOT NULL, /*bom特性代码*/
bmv04       varchar2(10) DEFAULT ' ' NOT NULL, /*属性代码,资料来源为元件款式*/
bmv05       date DEFAULT sysdate NOT NULL, /*生效日期*/
bmv06       date DEFAULT sysdate,    /*失效日期                               */
bmv07       varchar2(20) DEFAULT ' ' NOT NULL, /*属性值/主件属性编号,若固定  */
bmv08       varchar2(1) DEFAULT ' ' NOT NULL, /*固定属性类型:1-取主件值,2-自 */
bmv09       number(10) DEFAULT '0' NOT NULL /*项次*/
);

alter table bmv_file add  constraint bmv_pk primary key  (bmv01,bmv02,bmv03,bmv04,bmv05) enable validate;
grant select on bmv_file to tiptopgp;
grant update on bmv_file to tiptopgp;
grant delete on bmv_file to tiptopgp;
grant insert on bmv_file to tiptopgp;
grant index on bmv_file to public;
grant select on bmv_file to ods;
