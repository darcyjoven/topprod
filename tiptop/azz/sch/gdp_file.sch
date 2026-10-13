/*
================================================================================
檔案代號:gdp_file
檔案名稱:事件检知器
檔案目的:事件检知器
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdp_file
(
gdp01       date DEFAULT sysdate NOT NULL, /*日期*/
gdp02       varchar2(20) DEFAULT ' ' NOT NULL, /*时间(时:分:秒.毫秒)*/
gdp03       varchar2(10) DEFAULT ' ' NOT NULL, /*使用者*/
gdp04       varchar2(20) DEFAULT ' ' NOT NULL, /*程序代码*/
gdp05       varchar2(1) DEFAULT ' ' NOT NULL, /*类别 S(系统)/G(一般)/D(细节)*/
gdp06       varchar2(1) DEFAULT ' ' NOT NULL, /*等级 W(警告)/E(错误)/A(允许)*/
gdp07       varchar2(20),            /*资料库(含营运中心编号)                 */
gdp08       varchar2(255) DEFAULT ' ' NOT NULL, /*说明*/
gdp09       varchar2(20) DEFAULT ' ' NOT NULL, /*Server IP*/
gdp10       varchar2(20) DEFAULT ' ' NOT NULL, /*Client IP*/
gdp11       varchar2(20) DEFAULT ' ' NOT NULL /*Process ID*/
);

alter table gdp_file add  constraint gdp_pk primary key  (gdp01,gdp02,gdp03,gdp09,gdp11) enable validate;
grant select on gdp_file to tiptopgp;
grant update on gdp_file to tiptopgp;
grant delete on gdp_file to tiptopgp;
grant insert on gdp_file to tiptopgp;
grant index on gdp_file to public;
grant select on gdp_file to ods;
