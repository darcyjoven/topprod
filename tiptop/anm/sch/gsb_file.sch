/*
================================================================================
檔案代號:gsb_file
檔案名稱:票券外汇投资基本资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gsb_file
(
gsb01       varchar2(20) NOT NULL,   /*投资单号                               */
gsb02       varchar2(10),            /*经办人员                               */
gsb03       date,                    /*投资日期                               */
gsb04       date,                    /*平仓期限                               */
gsb05       varchar2(4),             /*投资种类                               */
gsb06       varchar2(30),            /*投资标的                               */
gsb07       varchar2(4),             /*No Use                                 */
gsb08       number(9,4),             /*No Use                                 */
gsb09       number(20,6),            /*单位价格                               */
gsb10       number(15,3),            /*投资数量                               */
gsb101      number(20,6),            /*投资金额                               */
gsb11       number(15,3),            /*平仓数量                               */
gsb111      number(20,6),            /*平仓金额                               */
gsb12       number(15,3),            /*留仓数量                               */
gsb121      number(20,6),            /*留仓金额                               */
gsb13       varchar2(30),            /*存款帐号                               */
gsb14       number(7,4),             /*No Use                                 */
gsb15       number(20,6),            /*支出总额                               */
gsb16       number(20,6),            /*累积损益                               */
gsb17       number(15,3),            /*No Use                                 */
gsb18       varchar2(1),             /*No Use                                 */
gsb19       varchar2(1),             /*No Use                                 */
gsb20       varchar2(1),             /*No Use                                 */
gsbglno     varchar2(12),            /*No Use                                 */
gsbgldat    date,                    /*No Use                                 */
gsbconf     varchar2(1),             /*确认码                                 */
gsbacti     varchar2(1),             /*资料有效码                             */
gsbuser     varchar2(10),            /*资料所有者                             */
gsbgrup     varchar2(10),            /*资料所有部门                           */
gsbmodu     varchar2(10),            /*资料更改者                             */
gsbdate     date,                    /*最近更改日                             */
gsbud01     varchar2(255),           /*自订字段-Textedit                      */
gsbud02     varchar2(40),            /*自订字段-文字                          */
gsbud03     varchar2(40),            /*自订字段-文字                          */
gsbud04     varchar2(40),            /*自订字段-文字                          */
gsbud05     varchar2(40),            /*自订字段-文字                          */
gsbud06     varchar2(40),            /*自订字段-文字                          */
gsbud07     number(15,3),            /*自订字段-数值                          */
gsbud08     number(15,3),            /*自订字段-数值                          */
gsbud09     number(15,3),            /*自订字段-数值                          */
gsbud10     number(10),              /*自订字段-整数                          */
gsbud11     number(10),              /*自订字段-整数                          */
gsbud12     number(10),              /*自订字段-整数                          */
gsbud13     date,                    /*自订字段-日期                          */
gsbud14     date,                    /*自订字段-日期                          */
gsbud15     date,                    /*自订字段-日期                          */
gsblegal    varchar2(10) NOT NULL,   /*所属法人                               */
gsboriu     varchar2(10),            /*资料建立者                             */
gsborig     varchar2(10)             /*资料建立部门                           */
);

alter table gsb_file add  constraint gsb_pk primary key  (gsb01) enable validate;
grant select on gsb_file to tiptopgp;
grant update on gsb_file to tiptopgp;
grant delete on gsb_file to tiptopgp;
grant insert on gsb_file to tiptopgp;
grant index on gsb_file to public;
grant select on gsb_file to ods;
