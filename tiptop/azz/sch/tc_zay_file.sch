/*
================================================================================
檔案代號:tc_zay_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zay_file
(
zay01       varchar2(80) NOT NULL,   /*查询单id                               */
zay02       number(5) NOT NULL,      /*序号                                   */
zay03       varchar2(1) NOT NULL,    /*客制否                                 */
zay04       varchar2(1),             /*转换项目                               */
zay05       varchar2(80) NOT NULL,   /*原转换值                               */
zay06       varchar2(1),             /*取代类型                               */
zay07       varchar2(80)             /*取代值                                 */
);

grant select on tc_zay_file to tiptopgp;
grant update on tc_zay_file to tiptopgp;
grant delete on tc_zay_file to tiptopgp;
grant insert on tc_zay_file to tiptopgp;
grant index on tc_zay_file to public;
grant select on tc_zay_file to ods;
