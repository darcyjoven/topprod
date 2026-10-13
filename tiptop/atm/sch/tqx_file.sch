/*
================================================================================
檔案代號:tqx_file
檔案名稱:提案单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqx_file
(
tqx01       varchar2(20) NOT NULL,   /*提案单号                               */
tqx02       date,                    /*提案日期                               */
tqx03       varchar2(10),            /*活动类型                               */
tqx04       varchar2(10),            /*档期类型                               */
tqx05       varchar2(80),            /*活动名称                               */
tqx06       varchar2(80),            /*对应客户档期                           */
tqx07       varchar2(1),             /*状态码                                 */
tqx08       varchar2(4),             /*税种                                   */
tqx09       varchar2(4),             /*币种                                   */
tqx10       number(5),               /*进货折扣前置期                         */
tqx11       number(5),               /*进货折扣延后期                         */
tqx12       varchar2(10),            /*提案组织编码                           */
tqx13       varchar2(10),            /*债权代码                               */
tqx14       number(9,4),             /*税率                                   */
tqx15       varchar2(1),             /*联数                                   */
tqx16       varchar2(1),             /*含税否                                 */
tqx17       number(20,6),            /*费用总金额                             */
tqx18       number(20,6),            /*总目标税前金额                         */
tqx19       number(20,6),            /*总目标税后金额                         */
tqxacti     varchar2(1),             /*资料有效码                             */
tqxuser     varchar2(10),            /*资料所有者                             */
tqxgrup     varchar2(10),            /*资料所有部门                           */
tqxmodu     varchar2(10),            /*资料更改者                             */
tqxdate     date,                    /*最近更改日                             */
tqxud01     varchar2(255),           /*自订字段-Textedit                      */
tqxud02     varchar2(40),            /*自订字段-文字                          */
tqxud03     varchar2(40),            /*自订字段-文字                          */
tqxud04     varchar2(40),            /*自订字段-文字                          */
tqxud05     varchar2(40),            /*自订字段-文字                          */
tqxud06     varchar2(40),            /*自订字段-文字                          */
tqxud07     number(15,3),            /*自订字段-数值                          */
tqxud08     number(15,3),            /*自订字段-数值                          */
tqxud09     number(15,3),            /*自订字段-数值                          */
tqxud10     number(10),              /*自订字段-整数                          */
tqxud11     number(10),              /*自订字段-整数                          */
tqxud12     number(10),              /*自订字段-整数                          */
tqxud13     date,                    /*自订字段-日期                          */
tqxud14     date,                    /*自订字段-日期                          */
tqxud15     date,                    /*自订字段-日期                          */
tqxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
tqxoriu     varchar2(10),            /*资料建立者                             */
tqxorig     varchar2(10)             /*资料建立部门                           */
);

alter table tqx_file add  constraint tqx_pk primary key  (tqx01) enable validate;
grant select on tqx_file to tiptopgp;
grant update on tqx_file to tiptopgp;
grant delete on tqx_file to tiptopgp;
grant insert on tqx_file to tiptopgp;
grant index on tqx_file to public;
grant select on tqx_file to ods;
