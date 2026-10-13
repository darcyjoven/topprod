/*
================================================================================
檔案代號:sgd_file
檔案名稱:工单工艺单元资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgd_file
(
sgd00       varchar2(20) NOT NULL,   /*工单编号                               */
sgd01       varchar2(40) NOT NULL,   /*料件编号                               */
sgd02       varchar2(10) NOT NULL,   /*工艺编号                               */
sgd03       number(5) NOT NULL,      /*工艺序号                               */
sgd04       varchar2(10) NOT NULL,   /*工作站编号                             */
sgd05       varchar2(10) NOT NULL,   /*单元编号                               */
sgd06       number(10),              /*零件数                                 */
sgd07       number(8,3),             /*单位工时                               */
sgd08       number(8,3),             /*单元工时                               */
sgd09       number(15,3),            /*单位人力                               */
sgd10       number(15,3),            /*单位机时                               */
sgd11       number(15,3),            /*单元机时                               */
sgdslk02    number(15,3),            /*现实工时                               */
sgdslk03    number(20,6),            /*标准工价                               */
sgdslk04    number(20,6),            /*现实工价                               */
sgdslk05    number(10),              /*单元顺序                               */
sgd13       varchar2(1) DEFAULT ' ' NOT NULL, /*可委外否*/
sgd14       varchar2(1),             /*可报工否                               */
sgdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgd012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgd_file add  constraint sgd_pk primary key  (sgd00,sgd01,sgd02,sgd03,sgd04,sgd05,sgd012) enable validate;
grant select on sgd_file to tiptopgp;
grant update on sgd_file to tiptopgp;
grant delete on sgd_file to tiptopgp;
grant insert on sgd_file to tiptopgp;
grant index on sgd_file to public;
grant select on sgd_file to ods;
