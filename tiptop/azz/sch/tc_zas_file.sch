/*
================================================================================
檔案代號:tc_zas_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zas_file
(
zas01       varchar2(80) NOT NULL,   /*查询单id                               */
zas02       number(5) NOT NULL,      /*条件式序号                             */
zas03       varchar2(5),             /*(                                      */
zas04       varchar2(15),            /*档案代码                               */
zas05       varchar2(20),            /*字段代码                               */
zas06       varchar2(5),             /*条件式                                 */
zas07       varchar2(20),            /*档案代码                               */
zas08       varchar2(80),            /*字段代码/数值                          */
zas09       varchar2(5),             /*)                                      */
zas10       varchar2(1),             /*or/and                                 */
zas11       varchar2(1) NOT NULL     /*客制码                                 */
);

grant select on tc_zas_file to tiptopgp;
grant update on tc_zas_file to tiptopgp;
grant delete on tc_zas_file to tiptopgp;
grant insert on tc_zas_file to tiptopgp;
grant index on tc_zas_file to public;
grant select on tc_zas_file to ods;
