/*
================================================================================
檔案代號:srg_file
檔案名稱:报工资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table srg_file
(
srg01       varchar2(20) NOT NULL,   /*报工单号                               */
srg02       number(5) NOT NULL,      /*项次                                   */
srg03       varchar2(40),            /*产品编号                               */
srg04       varchar2(4),             /*生产单位                               */
                                     /*default ima55                          */
srg05       number(15,3),            /*良品数                                 */
srg06       number(15,3),            /*不良品数                               */
srg07       number(15,3),            /*报废数量                               */
srg08       varchar2(5),             /*报工时间起                             */
srg09       varchar2(5),             /*报工时间迄                             */
srg10       number(15,3),            /*工时(分)                               */
srg11       varchar2(20),            /*入库单号                               */
srg12       varchar2(20),            /*fqc单号                                */
srg13       varchar2(1),             /*主/联/副/再生产品                      */
                                     /*1:Master Product ; 2:Corelation Product; 3:Byproduct ; 4:Regeneration Product*/
srg14       varchar2(40),            /*入库产品料号                           */
srg15       varchar2(1),             /*检验否(y/n)                            */
srg16       varchar2(20),            /*工单编号                               */
srg17       number(15,3),            /*已入库量                               */
srg18       number(15,3),            /*已FQC量                                */
srg930      varchar2(10),            /*成本中心                               */
srgud01     varchar2(255),           /*自订字段-Textedit                      */
srgud02     varchar2(40),            /*自订字段-文字                          */
srgud03     varchar2(40),            /*自订字段-文字                          */
srgud04     varchar2(40),            /*自订字段-文字                          */
srgud05     varchar2(40),            /*自订字段-文字                          */
srgud06     varchar2(40),            /*自订字段-文字                          */
srgud07     number(15,3),            /*自订字段-数值                          */
srgud08     number(15,3),            /*自订字段-数值                          */
srgud09     number(15,3),            /*自订字段-数值                          */
srgud10     number(10),              /*自订字段-整数                          */
srgud11     number(10),              /*自订字段-整数                          */
srgud12     number(10),              /*自订字段-整数                          */
srgud13     date,                    /*自订字段-日期                          */
srgud14     date,                    /*自订字段-日期                          */
srgud15     date,                    /*自订字段-日期                          */
srg19       number(15,3),            /*机时(分)                               */
srgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
srglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table srg_file add  constraint srg_pk primary key  (srg01,srg02) enable validate;
grant select on srg_file to tiptopgp;
grant update on srg_file to tiptopgp;
grant delete on srg_file to tiptopgp;
grant insert on srg_file to tiptopgp;
grant index on srg_file to public;
grant select on srg_file to ods;
