/*
================================================================================
檔案代號:obw_file
檔案名稱:车辆基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obw_file
(
obw01       varchar2(10) NOT NULL,   /*车辆编号                               */
obw02       varchar2(4),             /*类型                                   */
obw03       varchar2(16),            /*车辆厂牌                               */
obw04       varchar2(20),            /*车辆型号                               */
obw05       varchar2(1),             /*车辆级别                               */
obw06       varchar2(1),             /*所有权                                 */
obw07       varchar2(1),             /*车辆状态                               */
obw08       varchar2(16),            /*车辆号码                               */
obw09       varchar2(20),            /*引擎号码                               */
obw10       varchar2(20),            /*底盘号码                               */
obw11       date,                    /*出厂日期                               */
obw12       date,                    /*购买日期                               */
obw13       number(5),               /*已行驶里程                             */
obw14       varchar2(10),            /*保管人                                 */
obw15       varchar2(4),             /*保养群组                               */
obw16       varchar2(10),            /*驾驶员                                 */
obw17       varchar2(10),            /*随车人员一                             */
obw18       varchar2(10),            /*随车人员二                             */
obw19       varchar2(10),            /*随车人员三                             */
obw20       varchar2(6),             /*车队编号                               */
obw21       varchar2(1),             /*外租车计价方式                         */
obw22       number(20,6),            /*外租车单位金额                         */
obw23       varchar2(10),            /*财产编号                               */
obw24       varchar2(4),             /*财产附号                               */
obw25       varchar2(255),           /*备注                                   */
obwacti     varchar2(1),             /*资料有效码                             */
obwuser     varchar2(10),            /*资料所有者                             */
obwgrup     varchar2(10),            /*资料所有部门                           */
obwmodu     varchar2(10),            /*资料更改者                             */
obwdate     date,                    /*最近更改日                             */
obw26       date,                    /*最近保养日                             */
obwud01     varchar2(255),           /*自订字段-Textedit                      */
obwud02     varchar2(40),            /*自订字段-文字                          */
obwud03     varchar2(40),            /*自订字段-文字                          */
obwud04     varchar2(40),            /*自订字段-文字                          */
obwud05     varchar2(40),            /*自订字段-文字                          */
obwud06     varchar2(40),            /*自订字段-文字                          */
obwud07     number(15,3),            /*自订字段-数值                          */
obwud08     number(15,3),            /*自订字段-数值                          */
obwud09     number(15,3),            /*自订字段-数值                          */
obwud10     number(10),              /*自订字段-整数                          */
obwud11     number(10),              /*自订字段-整数                          */
obwud12     number(10),              /*自订字段-整数                          */
obwud13     date,                    /*自订字段-日期                          */
obwud14     date,                    /*自订字段-日期                          */
obwud15     date,                    /*自订字段-日期                          */
obworiu     varchar2(10),            /*资料建立者                             */
obworig     varchar2(10)             /*资料建立部门                           */
);

alter table obw_file add  constraint obw_pk primary key  (obw01) enable validate;
grant select on obw_file to tiptopgp;
grant update on obw_file to tiptopgp;
grant delete on obw_file to tiptopgp;
grant insert on obw_file to tiptopgp;
grant index on obw_file to public;
grant select on obw_file to ods;
