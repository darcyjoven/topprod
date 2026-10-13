/*
================================================================================
檔案代號:icb_file
檔案名稱:ICD料件基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icb_file
(
icb01       varchar2(40) NOT NULL,   /*主件料件编号                           */
icb02       varchar2(80),            /*光罩群组                               */
icb03       varchar2(80),            /*Product Line                           */
icb04       varchar2(80),            /*Chip Size(mm)Waafer                    */
icb05       number(15,3),            /*GROSS DIE                              */
icb06       varchar2(10),            /*Status for Wafer                       */
icb07       varchar2(10),            /*Purpose for Wafer                      */
icb08       varchar2(10),            /*Vender                                 */
icb09       varchar2(10),            /*Process Type for Wafer                 */
icb10       varchar2(255),           /*Reason for Version Change Wafer        */
icb11       varchar2(10),            /*Mask Vendor for Wafer                  */
icb12       varchar2(10),            /*Wafer Size(inch) for Wafer             */
icb13       varchar2(80),            /*Scribe-Line Width(um)Wafer             */
icb14       varchar2(10),            /*Technology for Wafer                   */
icb15       varchar2(10),            /*Wafer Thickness(mil) for Wafer         */
icb16       number(15,3),            /*Std Yld(%)                             */
icb17       number(15,6),            /*Claimed Yield(%)                       */
icb18       number(15,6),            /*Return Yield(%)                        */
icb19       number(15,6),            /*Fcst Yield(%)                          */
icb20       number(15,6),            /*Act Yield(%)                           */
icb21       varchar2(80),            /*CP Pgm Name cp                         */
icb22       varchar2(10),            /*CP Pgm Ver cp                          */
icb23       date,                    /*Released Date cp                       */
icb24       varchar2(6),             /*Alarm Bin cp                           */
icb25       varchar2(255),           /*ECN File cp                            */
icb26       number(15,3),            /*Hold Yied (%) cp                       */
icb27       varchar2(10),            /*供应商Site                             */
icb28       varchar2(1),             /*no use                                 */
icb29       varchar2(1),             /*no use                                 */
icb30       varchar2(1),             /*转code否                               */
icb31       varchar2(1),             /*no use                                 */
icb32       varchar2(20),            /*Duration                               */
icb33       date,                    /*Valid Date(rp)                         */
icb34       date,                    /*Valid Date(hold)                       */
icb35       date,                    /*Valid Date(close)                      */
icb36       varchar2(20),            /*Mask No                                */
icb37       varchar2(10),            /*Mask Ver                               */
icb38       varchar2(80),            /*Logo                                   */
icb39       varchar2(1),             /*New Code否                             */
icb40       varchar2(20),            /*no use                                 */
icb41       varchar2(20),            /*no use                                 */
icb42       varchar2(20),            /*no use                                 */
icb43       varchar2(1),             /*no use                                 */
icb44       varchar2(1),             /*no use                                 */
icb45       number(15,3),            /*no use                                 */
icb455      varchar2(1),             /*no use                                 */
icb46       varchar2(80),            /*no use ft                              */
icb47       varchar2(1),             /*ftno use ft                            */
icb48       varchar2(20),            /*no use                                 */
icb49       varchar2(20),            /*no use                                 */
icb50       number(15,3),            /*no use                                 */
icb51       varchar2(5),             /*no use                                 */
icb52       varchar2(5),             /*no use                                 */
icb53       varchar2(5),             /*no use                                 */
icb54       varchar2(1),             /*no use                                 */
icb55       varchar2(1),             /*no use                                 */
icb56       varchar2(1),             /*no use                                 */
icb57       varchar2(1),             /*no use                                 */
icb58       varchar2(255),           /*no use ft                              */
icb59       varchar2(255),           /*no use                                 */
icb60       varchar2(1),             /*no use                                 */
icb61       varchar2(1),             /*no use                                 */
icb62       varchar2(1),             /*no use                                 */
icb63       varchar2(1),             /*no use                                 */
icb64       varchar2(1),             /*no use                                 */
icb65       varchar2(1),             /*no use                                 */
icb66       varchar2(1),             /*no use                                 */
icb67       varchar2(10),            /*no use                                 */
icb68       varchar2(20),            /*no use                                 */
icb69       varchar2(20),            /*no use                                 */
icb70       varchar2(20),            /*no use                                 */
icb71       varchar2(20),            /*Epoxy for ass                          */
icb72       varchar2(20),            /*Gold Wire for ass                      */
icb73       varchar2(20),            /*Compound for ass                       */
icb74       varchar2(2),             /*Soldering for ass                      */
icb75       varchar2(10),            /*Eqa Test  Program for ass              */
icb76       varchar2(6),             /*Outline Dimension                      */
icb77       varchar2(20),            /*no use                                 */
icb78       number(15,6),            /*Holding Yield (%) for ass              */
icb79       varchar2(80),            /*ICD group                              */
icbacti     varchar2(1),             /*资料有效码                             */
icbdate     date,                    /*最近更改日                             */
icbgrup     varchar2(10),            /*资料所有群                             */
icbmodu     varchar2(10),            /*资料更改者                             */
icbuser     varchar2(10),            /*资料所有者                             */
icbud01     varchar2(255),           /*自订字段-Textedit                      */
icbud02     varchar2(40),            /*自订字段-文字                          */
icbud03     varchar2(40),            /*自订字段-文字                          */
icbud04     varchar2(40),            /*自订字段-文字                          */
icbud05     varchar2(40),            /*自订字段-文字                          */
icbud06     varchar2(40),            /*自订字段-文字                          */
icbud07     number(15,3),            /*自订字段-数值                          */
icbud08     number(15,3),            /*自订字段-数值                          */
icbud09     number(15,3),            /*自订字段-数值                          */
icbud10     number(10),              /*自订字段-整数                          */
icbud11     number(10),              /*自订字段-整数                          */
icbud12     number(10),              /*自订字段-整数                          */
icbud13     date,                    /*自订字段-日期                          */
icbud14     date,                    /*自订字段-日期                          */
icbud15     date,                    /*自订字段-日期                          */
icboriu     varchar2(10),            /*资料建立者                             */
icborig     varchar2(10)             /*资料建立部门                           */
);

alter table icb_file add  constraint icb_pk primary key  (icb01) enable validate;
grant select on icb_file to tiptopgp;
grant update on icb_file to tiptopgp;
grant delete on icb_file to tiptopgp;
grant insert on icb_file to tiptopgp;
grant index on icb_file to public;
grant select on icb_file to ods;
