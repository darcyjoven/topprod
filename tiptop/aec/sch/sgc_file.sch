/*
================================================================================
檔案代號:sgc_file
檔案名稱:工艺单元资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sgc_file
(
sgc01       varchar2(40) NOT NULL,   /*料件编号                               */
sgc02       varchar2(10) NOT NULL,   /*工艺编号                               */
sgc03       number(5) NOT NULL,      /*工艺序号                               */
sgc04       varchar2(10) NOT NULL,   /*工作站编号                             */
sgc05       varchar2(10) NOT NULL,   /*单元编号                               */
sgc06       number(10),              /*零件数                                 */
sgc07       number(8,3),             /*单位工时                               */
sgc08       number(8,3),             /*单元工时                               */
sgc09       number(15,3),            /*单位人力                               */
sgc10       number(15,3),            /*单位机时                               */
sgc11       number(15,3),            /*单元机时                               */
sgc13       varchar2(1) DEFAULT ' ' NOT NULL, /*可委外否*/
sgc14       varchar2(1),             /*可报工否                               */
sgcslk01    varchar2(1),             /*可报工否                               */
sgcslk02    number(8,4),             /*现实工时                               */
sgcslk03    number(20,6),            /*标准工价                               */
sgcslk04    number(20,6),            /*现实工价                               */
sgcslk05    number(10),              /*单元顺序                               */
sgc012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgc_file add  constraint sgc_pk primary key  (sgc01,sgc02,sgc03,sgc04,sgc05,sgc012) enable validate;
grant select on sgc_file to tiptopgp;
grant update on sgc_file to tiptopgp;
grant delete on sgc_file to tiptopgp;
grant insert on sgc_file to tiptopgp;
grant index on sgc_file to public;
grant select on sgc_file to ods;
