/*
================================================================================
檔案代號:fil_file
檔案名稱:设备工单资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fil_file
(
fil00       varchar2(1),             /*工单性质                               */
fil01       varchar2(20) NOT NULL,   /*工单编号                               */
fil02       varchar2(20),            /*检查单号                               */
fil03       varchar2(20),            /*设备编号                               */
fil04       varchar2(4),             /*类型                                   */
fil05       varchar2(1),             /*工单状态                               */
fil06       number(5),               /*优先级                                 */
fil07       varchar2(255),           /*备注                                   */
fil08       varchar2(10),            /*申请人                                 */
fil09       varchar2(10),            /*申请部门                               */
fil10       date,                    /*申请日期                               */
fil11       varchar2(5),             /*申请时间                               */
fil12       date,                    /*预计开工                               */
fil13       date,                    /*预计完工                               */
fil14       date,                    /*实际开工日期                           */
fil141      varchar2(5),             /*实际开工时间                           */
fil15       date,                    /*实际完工日期                           */
fil151      varchar2(5),             /*预计完工时间                           */
fil16       varchar2(1),             /*保修期内                               */
fil17       number(20,6),            /*备件费用                               */
fil18       number(20,6),            /*附件费用                               */
fil19       number(20,6),            /*人工费用                               */
fil20       number(20,6),            /*服务费用                               */
fil21       varchar2(300),           /*问题描述                               */
filacti     varchar2(1),             /*资料有效码                             */
filconf     varchar2(1),             /*资料审核码                             */
filuser     varchar2(10),            /*资料所有者                             */
filgrup     varchar2(10),            /*资料所有部门                           */
filmodu     varchar2(10),            /*最后更改人员                           */
fildate     date,                    /*最后更改日期                           */
filud01     varchar2(255),           /*自订字段-Textedit                      */
filud02     varchar2(40),            /*自订字段-文字                          */
filud03     varchar2(40),            /*自订字段-文字                          */
filud04     varchar2(40),            /*自订字段-文字                          */
filud05     varchar2(40),            /*自订字段-文字                          */
filud06     varchar2(40),            /*自订字段-文字                          */
filud07     number(15,3),            /*自订字段-数值                          */
filud08     number(15,3),            /*自订字段-数值                          */
filud09     number(15,3),            /*自订字段-数值                          */
filud10     number(10),              /*自订字段-整数                          */
filud11     number(10),              /*自订字段-整数                          */
filud12     number(10),              /*自订字段-整数                          */
filud13     date,                    /*自订字段-日期                          */
filud14     date,                    /*自订字段-日期                          */
filud15     date,                    /*自订字段-日期                          */
filplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
fillegal    varchar2(10) NOT NULL,   /*所属法人                               */
filoriu     varchar2(10),            /*资料建立者                             */
filorig     varchar2(10)             /*资料建立部门                           */
);

alter table fil_file add  constraint fil_pk primary key  (fil01) enable validate;
grant select on fil_file to tiptopgp;
grant update on fil_file to tiptopgp;
grant delete on fil_file to tiptopgp;
grant insert on fil_file to tiptopgp;
grant index on fil_file to public;
grant select on fil_file to ods;
