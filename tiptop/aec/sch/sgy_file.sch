/*
================================================================================
檔案代號:sgy_file
檔案名稱:工单工艺单元变更档
檔案目的:工单工艺单元变更单身档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgy_file
(
sgy01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
sgy02       number(5) DEFAULT '0' NOT NULL, /*工艺序*/
sgy03       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
sgy04       varchar2(1) DEFAULT ' ' NOT NULL, /*变更方式*/
sgy05       varchar2(10) DEFAULT ' ' NOT NULL, /*单元编号*/
sgy06       varchar2(10),            /*原零件数                               */
sgy07       number(8,4),             /*原单位工时                             */
sgy08       number(8,4),             /*原单元工时                             */
sgy09       number(15,3),            /*原单位人力                             */
sgy10       number(8,4),             /*原单位机时                             */
sgy11       number(8,4),             /*原单元机时                             */
sgy12       varchar2(1),             /*原可托外否                             */
sgy13       varchar2(10),            /*新零件数                               */
sgy14       number(8,4),             /*新单位工时                             */
sgy15       number(8,4),             /*新单元工时                             */
sgy16       number(15,3),            /*新单位人力                             */
sgy17       number(8,4),             /*新单位机时                             */
sgy18       number(8,4),             /*新单元机时                             */
sgy19       varchar2(1),             /*新可托外否                             */
sgy20       varchar2(1),             /*原报工否                               */
sgy21       varchar2(1),             /*新报工否                               */
sgyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgylegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgy012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgy_file add  constraint sgy_pk primary key  (sgy01,sgy02,sgy03,sgy05,sgy012) enable validate;
grant select on sgy_file to tiptopgp;
grant update on sgy_file to tiptopgp;
grant delete on sgy_file to tiptopgp;
grant insert on sgy_file to tiptopgp;
grant index on sgy_file to public;
grant select on sgy_file to ods;
