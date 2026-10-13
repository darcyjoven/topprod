/*
================================================================================
檔案代號:fin_file
檔案名稱:设备保修工作日报维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fin_file
(
fin01       varchar2(20) NOT NULL,   /*工单编号                               */
fin02       varchar2(10) NOT NULL,   /*保修项目                               */
fin03       varchar2(6) NOT NULL,    /*工种                                   */
fin04       varchar2(10) NOT NULL,   /*人员编号                               */
fin05       varchar2(10),            /*部门编号                               */
fin06       varchar2(10),            /*班别                                   */
fin07       date,                    /*报工日期                               */
fin08       varchar2(5),             /*报工时间                               */
fin09       date,                    /*开工日期                               */
fin10       varchar2(5),             /*开工时间                               */
fin11       number(8,3),             /*投入工时                               */
fin12       varchar2(1),             /*No                                     */
finacti     varchar2(1),             /*资料有效码                             */
finuser     varchar2(10),            /*资料所有者                             */
fingrup     varchar2(10),            /*资料所有部门                           */
finmodu     varchar2(10),            /*最后更改人员                           */
findate     date,                    /*最后更改日期                           */
finud01     varchar2(255),           /*自订字段-Textedit                      */
finud02     varchar2(40),            /*自订字段-文字                          */
finud03     varchar2(40),            /*自订字段-文字                          */
finud04     varchar2(40),            /*自订字段-文字                          */
finud05     varchar2(40),            /*自订字段-文字                          */
finud06     varchar2(40),            /*自订字段-文字                          */
finud07     number(15,3),            /*自订字段-数值                          */
finud08     number(15,3),            /*自订字段-数值                          */
finud09     number(15,3),            /*自订字段-数值                          */
finud10     number(10),              /*自订字段-整数                          */
finud11     number(10),              /*自订字段-整数                          */
finud12     number(10),              /*自订字段-整数                          */
finud13     date,                    /*自订字段-日期                          */
finud14     date,                    /*自订字段-日期                          */
finud15     date,                    /*自订字段-日期                          */
finplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
finlegal    varchar2(10) NOT NULL,   /*所属法人                               */
finoriu     varchar2(10),            /*资料建立者                             */
finorig     varchar2(10)             /*资料建立部门                           */
);

alter table fin_file add  constraint fin_pk primary key  (fin01,fin02,fin03,fin04) enable validate;
grant select on fin_file to tiptopgp;
grant update on fin_file to tiptopgp;
grant delete on fin_file to tiptopgp;
grant insert on fin_file to tiptopgp;
grant index on fin_file to public;
grant select on fin_file to ods;
