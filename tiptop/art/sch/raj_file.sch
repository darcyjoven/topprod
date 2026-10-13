/*
================================================================================
檔案代號:raj_file
檔案名稱:满额促销单身档(二)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table raj_file
(
raj01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
raj02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
raj03       number(5) DEFAULT '0' NOT NULL, /*项次*/
raj04       varchar2(2) DEFAULT ' ' NOT NULL, /*数据类型01.产品、02.产品分类 */
raj05       varchar2(40),            /*编号                                   */
raj06       varchar2(4),             /*单位                                   */
rajacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
rajlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rajplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table raj_file add  constraint raj_pk primary key  (raj01,raj02,raj03,raj04,rajplant) enable validate;
grant select on raj_file to tiptopgp;
grant update on raj_file to tiptopgp;
grant delete on raj_file to tiptopgp;
grant insert on raj_file to tiptopgp;
grant index on raj_file to public;
grant select on raj_file to ods;
