/*
================================================================================
檔案代號:als_file
檔案名稱:外购提单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table als_file
(
als01       varchar2(20) NOT NULL,   /*到货单号                               */
                                     /*到貨單號                               */
als02       date,                    /*提单日期                               */
                                     /*提單日期(文件收到日期)                 */
als03       varchar2(20),            /*预购单号                               */
als04       varchar2(10),            /*帐款部门                               */
                                     /*帳款部門                               */
als05       varchar2(10),            /*付款厂商                               */
                                     /*付款廠商                               */
als06       varchar2(10),            /*出货厂商                               */
                                     /*出貨廠商 (Shipper)                     */
als07       varchar2(20),            /*提单编号                               */
                                     /*提單編號                               */
als08       varchar2(255),           /*备注一                                 */
                                     /*備註一                                 */
als09       varchar2(255),           /*备注二                                 */
                                     /*備註二                                 */
als10       varchar2(10),            /*付款条件                               */
                                     /*付款條件 (LC, TT, OA, DA, DP) 001114   */
als11       varchar2(4),             /*到货币种                               */
                                     /*到貨幣別                               */
als12       number(20,10),           /*到货汇率                               */
                                     /*到貨匯率 (先到單則以到單匯率,否則預估) */
als13       number(20,6),            /*到货金额                               */
                                     /*到貨金額                               */
als14       varchar2(255),           /*备注三                                 */
                                     /*備註三                                 */
als21       varchar2(30),            /*报单号码                               */
                                     /*報單號碼                               */
als22       number(15,3),            /*到货重量                               */
                                     /*到貨重量                               */
als23       varchar2(4),             /*重量单位                               */
                                     /*重量單位                               */
als31       number(20,6),            /*(运费)                                 */
                                     /*預估費用一金額 (運費)                  */
als32       number(20,6),            /*预估费用二金额                         */
                                     /*預估費用二金額 (報關費)                */
als33       number(20,6),            /*预估费用三金额                         */
                                     /*預估費用三金額 (倉租)                  */
als34       number(20,6),            /*预估费用四金额                         */
                                     /*預估費用四金額 (稅捐)                  */
als35       number(20,6),            /*预估费用五金额                         */
                                     /*預估費用五金額                         */
als36       number(20,6),            /*预估费用六金额                         */
                                     /*預估費用六金額                         */
als41       number(20,6),            /*实际费用一金额                         */
                                     /*實際費用一金額 (運費)                  */
als42       number(20,6),            /*实际费用二金额                         */
                                     /*實際費用二金額 (報關費)                */
als43       number(20,6),            /*实际费用三金额                         */
                                     /*實際費用三金額 (倉租)                  */
als44       number(20,6),            /*实际费用四金额                         */
                                     /*實際費用四金額 (稅捐)                  */
als45       number(20,6),            /*实际费用五金额                         */
                                     /*實際費用五金額                         */
als46       number(20,6),            /*实际费用六金额                         */
                                     /*實際費用六金額                         */
als41m      varchar2(6),             /*实际费用一发票年月份                   */
                                     /*實際費用一發票年月份                   */
als42m      varchar2(6),             /*实际费用二发票年月份                   */
                                     /*實際費用二發票年月份                   */
als43m      varchar2(6),             /*实际费用三发票年月份                   */
                                     /*實際費用三發票年月份                   */
als44m      varchar2(6),             /*实际费用四发票年月份                   */
                                     /*實際費用四發票年月份                   */
als45m      varchar2(6),             /*实际费用五发票年月份                   */
                                     /*實際費用五發票年月份                   */
als46m      varchar2(6),             /*实际费用六发票年月份                   */
                                     /*實際費用六發票年月份                   */
alsfirm     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
alsinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
alsacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
alsuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
alsgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
alsmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
alsdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
als930      varchar2(10),            /*成本中心                               */
alsud01     varchar2(255),           /*自订字段-Textedit                      */
alsud02     varchar2(40),            /*自订字段-文字                          */
alsud03     varchar2(40),            /*自订字段-文字                          */
alsud04     varchar2(40),            /*自订字段-文字                          */
alsud05     varchar2(40),            /*自订字段-文字                          */
alsud06     varchar2(40),            /*自订字段-文字                          */
alsud07     number(15,3),            /*自订字段-数值                          */
alsud08     number(15,3),            /*自订字段-数值                          */
alsud09     number(15,3),            /*自订字段-数值                          */
alsud10     number(10),              /*自订字段-整数                          */
alsud11     number(10),              /*自订字段-整数                          */
alsud12     number(10),              /*自订字段-整数                          */
alsud13     date,                    /*自订字段-日期                          */
alsud14     date,                    /*自订字段-日期                          */
alsud15     date,                    /*自订字段-日期                          */
alslegal    varchar2(10) NOT NULL,   /*所属法人                               */
als97       varchar2(10),            /*采购营运中心编号                       */
alsoriu     varchar2(10),            /*资料建立者                             */
alsorig     varchar2(10)             /*资料建立部门                           */
);

create        index als_03 on als_file (als03);
create        index als_04 on als_file (als07);
create        index als_02 on als_file (als02);
alter table als_file add  constraint als_pk primary key  (als01) enable validate;
grant select on als_file to tiptopgp;
grant update on als_file to tiptopgp;
grant delete on als_file to tiptopgp;
grant insert on als_file to tiptopgp;
grant index on als_file to public;
grant select on als_file to ods;
