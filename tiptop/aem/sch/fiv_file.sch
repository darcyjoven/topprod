/*
================================================================================
檔案代號:fiv_file
檔案名稱:设备保修工单库存异动单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fiv_file
(
fiv00       varchar2(1),             /*异动状态                               */
fiv01       varchar2(20) NOT NULL,   /*单据编号                               */
fiv02       varchar2(20),            /*工单单号                               */
fiv03       varchar2(255),           /*备注                                   */
fiv04       date,                    /*录入日期                               */
fiv05       date,                    /*扣帐日期                               */
fiv06       varchar2(10),            /*部门                                   */
fiv07       varchar2(10),            /*项目                                   */
fiv08       varchar2(1),             /*No                                     */
fiv09       varchar2(1),             /*No                                     */
fivconf     varchar2(1),             /*资料审核码                             */
fivpost     varchar2(1),             /*过帐否                                 */
fivuser     varchar2(10),            /*资料所有者                             */
fivgrup     varchar2(10),            /*资料所有部门                           */
fivmodu     varchar2(10),            /*最后更改人员                           */
fivdate     date,                    /*最后更改日期                           */
fivud01     varchar2(255),           /*自订字段-Textedit                      */
fivud02     varchar2(40),            /*自订字段-文字                          */
fivud03     varchar2(40),            /*自订字段-文字                          */
fivud04     varchar2(40),            /*自订字段-文字                          */
fivud05     varchar2(40),            /*自订字段-文字                          */
fivud06     varchar2(40),            /*自订字段-文字                          */
fivud07     number(15,3),            /*自订字段-数值                          */
fivud08     number(15,3),            /*自订字段-数值                          */
fivud09     number(15,3),            /*自订字段-数值                          */
fivud10     number(10),              /*自订字段-整数                          */
fivud11     number(10),              /*自订字段-整数                          */
fivud12     number(10),              /*自订字段-整数                          */
fivud13     date,                    /*自订字段-日期                          */
fivud14     date,                    /*自订字段-日期                          */
fivud15     date,                    /*自订字段-日期                          */
fivplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
fivlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fivoriu     varchar2(10),            /*资料建立者                             */
fivorig     varchar2(10)             /*资料建立部门                           */
);

alter table fiv_file add  constraint fiv_pk primary key  (fiv01) enable validate;
grant select on fiv_file to tiptopgp;
grant update on fiv_file to tiptopgp;
grant delete on fiv_file to tiptopgp;
grant insert on fiv_file to tiptopgp;
grant index on fiv_file to public;
grant select on fiv_file to ods;
