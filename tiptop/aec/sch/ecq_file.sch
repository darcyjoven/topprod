/*
================================================================================
檔案代號:ecq_file
檔案名稱:工单制程变更档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ecq_file
(
ecq01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
ecq02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ecq03       varchar2(20),            /*工单单号                               */
ecq04       varchar2(40),            /*料号                                   */
ecq05       varchar2(10),            /*工艺编号                               */
ecq06       number(5),               /*工艺序号                               */
ecq07       varchar2(10),            /*作业编号                               */
ecq08       varchar2(10),            /*单元明细编号                           */
ecq09       varchar2(10),            /*变更前工作站                           */
ecq09a      varchar2(10),            /*变更后工作站                           */
ecq10       date,                    /*变更前预计开工日                       */
ecq10a      date,                    /*变更后预计开工日                       */
ecq11       date,                    /*变更前预计完工日                       */
ecq11a      date,                    /*变更后预计完工日                       */
ecq12       number(8,4),             /*变更前现实单元工时                     */
ecq12a      number(8,4),             /*变更后现实单元工时                     */
ecq13       number(20,6),            /*变更前现实工价                         */
ecq13a      number(20,6),            /*变更后现实工价                         */
ecq14       varchar2(1),             /*变更前委外否                           */
ecq14a      varchar2(1),             /*变更后委外否                           */
ecq15       varchar2(10),            /*no use                                 */
ecq15a      varchar2(10),            /*no use                                 */
ecq20       number(5),               /*单元明细次序                           */
ecq21       number(10),              /*零件数                                 */
ecq22       number(8,4),             /*单位工时                               */
ecq23       number(8,4),             /*单元工时                               */
ecq24       number(8,4),             /*现实工时                               */
ecq25       number(20,6),            /*标准工价                               */
ecq26       number(20,6),            /*现实工价                               */
ecq27       number(15,3),            /*单位机时                               */
ecq28       number(15,3),            /*单元机时                               */
ecq29       number(15,3),            /*单位人力                               */
ecq30       varchar2(10),            /*单元编号                               */
ecqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ecqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ecq_file add  constraint ecq_pk primary key  (ecq01,ecq02) enable validate;
grant select on ecq_file to tiptopgp;
grant update on ecq_file to tiptopgp;
grant delete on ecq_file to tiptopgp;
grant insert on ecq_file to tiptopgp;
grant index on ecq_file to public;
grant select on ecq_file to ods;
