/*
================================================================================
檔案代號:icw_file
檔案名稱:NEW CODE申请单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table icw_file
(
icw01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号码*/
icw02       varchar2(10),            /*客户编号                               */
icw03       varchar2(10),            /*业务员                                 */
icw04       varchar2(10),            /*部门                                   */
icw05       varchar2(40),            /*产品型号                               */
icw06       varchar2(1),             /*Multi Die                              */
icw07       varchar2(40),            /*外编子体料号                           */
icw08       varchar2(40),            /*外编母体料号                           */
icw09       varchar2(40),            /*光罩料号                               */
icw10       varchar2(1),             /*销售审核                               */
icw11       varchar2(20),            /*光罩采购单                             */
icw12       varchar2(40),            /*Wafer 料号                             */
icw13       varchar2(80),            /*Code                                   */
icw14       date,                    /*生成日期                               */
icw15       date,                    /*审核日期                               */
icw16       date,                    /*取消日期                               */
icw17       date,                    /*Wafer首次发出日期                      */
icw18       varchar2(1),             /*状况码                                 */
icw19       varchar2(80),            /*光罩路径                               */
icw20       varchar2(20),            /*Wafer首次发出采购单号                  */
icw21       varchar2(1),             /*no use                                 */
icw22       varchar2(40),            /*母体编号                               */
icw23       varchar2(10),            /*版本                                   */
icwacti     varchar2(1),             /*资料有效码                             */
icwdate     date,                    /*最近更改日                             */
icwgrup     varchar2(10),            /*资料所有部门                           */
icwmksg     varchar2(1),             /*是否签核                               */
icwmodu     varchar2(10),            /*资料更改者                             */
icwuser     varchar2(10),            /*资料所有者                             */
icwud01     varchar2(255),           /*自订字段-Textedit                      */
icwud02     varchar2(40),            /*自订字段-文字                          */
icwud03     varchar2(40),            /*自订字段-文字                          */
icwud04     varchar2(40),            /*自订字段-文字                          */
icwud05     varchar2(40),            /*自订字段-文字                          */
icwud06     varchar2(40),            /*自订字段-文字                          */
icwud07     number(15,3),            /*自订字段-数值                          */
icwud08     number(15,3),            /*自订字段-数值                          */
icwud09     number(15,3),            /*自订字段-数值                          */
icwud10     number(10),              /*自订字段-整数                          */
icwud11     number(10),              /*自订字段-整数                          */
icwud12     number(10),              /*自订字段-整数                          */
icwud13     date,                    /*自订字段-日期                          */
icwud14     date,                    /*自订字段-日期                          */
icwud15     date,                    /*自订字段-日期                          */
icwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
icwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
icworiu     varchar2(10),            /*资料建立者                             */
icworig     varchar2(10)             /*资料建立部门                           */
);

alter table icw_file add  constraint icw_pk primary key  (icw01) enable validate;
grant select on icw_file to tiptopgp;
grant update on icw_file to tiptopgp;
grant delete on icw_file to tiptopgp;
grant insert on icw_file to tiptopgp;
grant index on icw_file to public;
grant select on icw_file to ods;
