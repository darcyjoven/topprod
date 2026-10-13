/*
================================================================================
檔案代號:tc_zal_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zal_file
(
zal01       varchar2(80) NOT NULL,   /*查询单ID                               */
zal02       number(5) NOT NULL,      /*序号                                   */
zal03       varchar2(1) NOT NULL,    /*语言别                                 */
zal04       varchar2(80),            /*字段编号                               */
zal05       varchar2(80),            /*显示名称                               */
zal06       varchar2(255),           /*备注                                   */
zal07       varchar2(1) NOT NULL,    /*客制码                                 */
zal08       number(10),              /*字段宽度                               */
zal09       varchar2(1)              /*字段属性                               */
);

grant select on tc_zal_file to tiptopgp;
grant update on tc_zal_file to tiptopgp;
grant delete on tc_zal_file to tiptopgp;
grant insert on tc_zal_file to tiptopgp;
grant index on tc_zal_file to public;
grant select on tc_zal_file to ods;
