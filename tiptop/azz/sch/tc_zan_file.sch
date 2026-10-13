/*
================================================================================
檔案代號:tc_zan_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zan_file
(
zan01       varchar2(80) NOT NULL,   /*查询单id                               */
zan02       number(5) NOT NULL,      /*序号                                   */
zan03       varchar2(1),             /*计算式-aggr                            */
zan04       varchar2(1),             /*依group字段                            */
zan05       varchar2(80),            /*group字段序号                          */
zan06       varchar2(255),           /*备注                                   */
zan07       varchar2(1),             /*显示方式                               */
zan08       varchar2(1) NOT NULL     /*客制码                                 */
);

grant select on tc_zan_file to tiptopgp;
grant update on tc_zan_file to tiptopgp;
grant delete on tc_zan_file to tiptopgp;
grant insert on tc_zan_file to tiptopgp;
grant index on tc_zan_file to public;
grant select on tc_zan_file to ods;
