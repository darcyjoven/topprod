/*
================================================================================
檔案代號:zan_file
檔案名稱:定义查询计算(Sum)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zan_file
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

alter table zan_file add  constraint zan_pk primary key  (zan01,zan02,zan08) enable validate;
grant select on zan_file to tiptopgp;
grant update on zan_file to tiptopgp;
grant delete on zan_file to tiptopgp;
grant insert on zan_file to tiptopgp;
grant index on zan_file to public;
grant select on zan_file to ods;
