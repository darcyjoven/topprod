/*
================================================================================
檔案代號:bza_file
檔案名稱:保税机器设备单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bza_file
(
bza01       varchar2(20) NOT NULL,   /*机器设备编号                           */
bza02       varchar2(80),            /*机器设备中文名称                       */
bza03       varchar2(80),            /*机器设备英文名称                       */
bza04       varchar2(30),            /*机器设备规格                           */
bza05       varchar2(1),             /*类型                                   */
                                     /*1.Master Item 2.Accessory              */
bza06       varchar2(40),            /*主件编号                               */
bza07       varchar2(30),            /*报单号码                               */
bza08       varchar2(4),             /*单位                                   */
bza09       number(15,3),            /*数量                                   */
bza10       number(20,6),            /*税捐记帐金额                           */
bza11       varchar2(30),            /*管理局核准文号                         */
bza12       date,                    /*放行日期                               */
bza13       date,                    /*记帐到期日                             */
bza14       date,                    /*稽核日期                               */
bza15       varchar2(255),           /*备注                                   */
bza16       number(15,3),            /*帐面结余数量                           */
bza17       varchar2(1),             /*No Use                                 */
bza18       varchar2(1),             /*No Use                                 */
bza19       varchar2(1),             /*No Use                                 */
bza20       varchar2(1),             /*No Use                                 */
bzaacti     varchar2(1),             /*资料有效码                             */
bzauser     varchar2(10),            /*资料所有者                             */
bzagrup     varchar2(10),            /*资料所有部门                           */
bzamodu     varchar2(10),            /*资料更改者                             */
bzadate     date,                    /*最近更改日                             */
bzaud01     varchar2(255),           /*自订字段-Textedit                      */
bzaud02     varchar2(40),            /*自订字段-文字                          */
bzaud03     varchar2(40),            /*自订字段-文字                          */
bzaud04     varchar2(40),            /*自订字段-文字                          */
bzaud05     varchar2(40),            /*自订字段-文字                          */
bzaud06     varchar2(40),            /*自订字段-文字                          */
bzaud07     number(15,3),            /*自订字段-数值                          */
bzaud08     number(15,3),            /*自订字段-数值                          */
bzaud09     number(15,3),            /*自订字段-数值                          */
bzaud10     number(10),              /*自订字段-整数                          */
bzaud11     number(10),              /*自订字段-整数                          */
bzaud12     number(10),              /*自订字段-整数                          */
bzaud13     date,                    /*自订字段-日期                          */
bzaud14     date,                    /*自订字段-日期                          */
bzaud15     date,                    /*自订字段-日期                          */
bzaorig     varchar2(10),            /*资料建立部门                           */
bzaoriu     varchar2(10)             /*资料建立者                             */
);

alter table bza_file add  constraint bza_pk primary key  (bza01) enable validate;
grant select on bza_file to tiptopgp;
grant update on bza_file to tiptopgp;
grant delete on bza_file to tiptopgp;
grant insert on bza_file to tiptopgp;
grant index on bza_file to public;
grant select on bza_file to ods;
