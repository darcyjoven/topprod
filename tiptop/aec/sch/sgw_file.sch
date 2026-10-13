/*
================================================================================
檔案代號:sgw_file
檔案名稱:产品工艺单元变更档
檔案目的:产品工艺单元变更单身档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sgw_file
(
sgw01       varchar2(40) DEFAULT ' ' NOT NULL, /*产品料号*/
sgw02       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺编号*/
sgw03       number(5) DEFAULT '0' NOT NULL, /*工艺序*/
sgw04       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
sgw05       varchar2(1) DEFAULT ' ' NOT NULL, /*变更方式 1-新增 2-删除 3-更改*/
sgw06       varchar2(10) DEFAULT ' ' NOT NULL, /*单元编号*/
sgw07       varchar2(10),            /*原零件数                               */
sgw08       varchar2(10),            /*原单位工时                             */
sgw09       number(8,4),             /*原单元工时                             */
sgw10       number(15,3),            /*原单位人力                             */
sgw11       varchar2(10),            /*原单位机时                             */
sgw12       number(8,4),             /*原单元机时                             */
sgw13       varchar2(1),             /*原可委外否                             */
sgw14       varchar2(10),            /*新零件数                               */
sgw15       varchar2(10),            /*新单位工时                             */
sgw16       number(8,4),             /*新单元工时                             */
sgw17       number(15,3),            /*新单位人力                             */
sgw18       number(8,4),             /*新单位机时                             */
sgw19       number(8,4),             /*新单元机时                             */
sgw20       varchar2(1),             /*新可委外否                             */
sgwslk01    number(10),              /*原单元顺序                             */
sgwslk03    number(8,4),             /*原现实工时                             */
sgwslk04    number(20,6),            /*原标准工价                             */
sgwslk05    number(20,6),            /*原现实工价                             */
sgwslk06    number(10),              /*新单元顺序                             */
sgwslk08    number(8,4),             /*新现实工时                             */
sgwslk09    number(20,6),            /*新标准工价                             */
sgwslk10    number(20,6),            /*新现实工价                             */
sgw21       varchar2(1),             /*原可报工否                             */
sgw22       varchar2(1),             /*新报工否                               */
sgw012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgw_file add  constraint sgw_pk primary key  (sgw01,sgw02,sgw03,sgw04,sgw06,sgw012) enable validate;
grant select on sgw_file to tiptopgp;
grant update on sgw_file to tiptopgp;
grant delete on sgw_file to tiptopgp;
grant insert on sgw_file to tiptopgp;
grant index on sgw_file to public;
grant select on sgw_file to ods;
