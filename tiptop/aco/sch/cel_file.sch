/*
================================================================================
檔案代號:cel_file
檔案名稱:归并后BOM单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cel_file
(
cel01       varchar2(10) DEFAULT ' ' NOT NULL, /*归并后序号*/
cel02       varchar2(10) DEFAULT ' ' NOT NULL, /*BOM版本*/
cel03       varchar2(20) DEFAULT ' ' NOT NULL, /*特性代码*/
cel04       number(10) DEFAULT '0' NOT NULL, /*单身项次*/
cel05       varchar2(10),            /*归并后序号                             */
cel06       varchar2(40),            /*海关商品编号                           */
cel07       varchar2(4),             /*申报计量单位                           */
cel08       number(20,8),            /*单耗                                   */
cel09       number(20,8),            /*损耗率                                 */
cel10       varchar2(1)              /*类型                                   */
);

alter table cel_file add  constraint cel_pk primary key  (cel01,cel02,cel03,cel04) enable validate;
grant select on cel_file to tiptopgp;
grant update on cel_file to tiptopgp;
grant delete on cel_file to tiptopgp;
grant insert on cel_file to tiptopgp;
grant index on cel_file to public;
grant select on cel_file to ods;
