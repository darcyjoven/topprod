/*
================================================================================
檔案代號:icc_file
檔案名稱:ICD料件分群基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icc_file
(
icc01       varchar2(10) NOT NULL,   /*群组编号                               */
icc02       varchar2(80),            /*光罩群组                               */
icc03       varchar2(80),            /*生产线                                 */
icc04       number(15,3),            /*芯片尺寸                               */
icc05       number(15,3),            /*切割尺寸                               */
icc06       varchar2(10),            /*状态                                   */
icc07       varchar2(10),            /*目的                                   */
icc08       varchar2(10),            /*供应商                                 */
icc09       varchar2(10),            /*流程形态                               */
icc10       varchar2(255),           /*版本变更理由                           */
icc11       varchar2(10),            /*光罩厂商                               */
icc12       varchar2(10),            /*WAFER 尺寸                             */
icc13       varchar2(5),             /*Scribe-Line Width                      */
icc14       varchar2(80),            /*技术                                   */
icc15       varchar2(10),            /*WAFER厚度                              */
icc16       number(15,3),            /*标准良率(%)                            */
icc17       number(15,6),            /*要求良率（%）                          */
icc18       number(15,6),            /*退回良率（%）                          */
icc19       number(15,6),            /*预估良率(%)                            */
icc20       number(15,6),            /*实际良率（%）                          */
icc21       varchar2(80),            /*CP程序                                 */
icc22       varchar2(10),            /*CP程序版本                             */
icc23       date,                    /*发行日                                 */
icc24       varchar2(5),             /*警告                                   */
icc25       varchar2(255),           /*ECN号码                                */
icc26       number(15,3),            /*暂停良率(%)                            */
icc27       varchar2(10),            /*供应商Site                             */
icc28       varchar2(1),             /*no use                                 */
icc29       varchar2(1),             /*no use                                 */
icc30       varchar2(1),             /*转Code？                               */
icc31       varchar2(1),             /*no user                                */
icc32       varchar2(80),            /*Duration                               */
icc33       date,                    /*Valid Date(RP)                         */
icc34       date,                    /*Valid Date(HOLD)                       */
icc35       date,                    /*Valid Date(CLOSE)                      */
icc36       varchar2(20),            /*光罩编码                               */
icc37       varchar2(10),            /*光罩版本                               */
icc38       varchar2(80),            /*Logo                                   */
icc39       varchar2(1),             /*no use                                 */
icc40       varchar2(20),            /*no use                                 */
icc41       varchar2(20),            /*no use                                 */
icc42       varchar2(20),            /*no use                                 */
icc43       varchar2(1),             /*no use                                 */
icc44       varchar2(1),             /*no use                                 */
icc45       number(15,3),            /*no use                                 */
icc455      varchar2(1),             /*no use                                 */
icc46       varchar2(80),            /*no use ft                              */
icc47       varchar2(1),             /*ftno use ft                            */
icc48       varchar2(20),            /*no use                                 */
icc49       varchar2(4),             /*no use                                 */
icc50       number(15,3),            /*no use                                 */
icc51       varchar2(5),             /*no use                                 */
icc52       varchar2(5),             /*no use                                 */
icc53       varchar2(5),             /*no use                                 */
icc54       varchar2(1),             /*no use                                 */
icc55       varchar2(1),             /*no use                                 */
icc56       varchar2(1),             /*no use                                 */
icc57       varchar2(1),             /*no use                                 */
icc58       varchar2(255),           /*no use ft                              */
icc59       varchar2(255),           /*no use                                 */
icc60       varchar2(1),             /*no use                                 */
icc61       varchar2(1),             /*no use                                 */
icc62       varchar2(1),             /*no use                                 */
icc63       varchar2(1),             /*no use                                 */
icc64       varchar2(1),             /*no use                                 */
icc65       varchar2(1),             /*no use                                 */
icc66       varchar2(1),             /*no use                                 */
icc67       varchar2(10),            /*no use                                 */
icc68       varchar2(20),            /*no use                                 */
icc69       varchar2(20),            /*no use                                 */
icc70       varchar2(80),            /*Leadframe ass                          */
icc71       varchar2(20),            /*Epoxy ass                              */
icc72       varchar2(20),            /*Gld Wire ass                           */
icc73       varchar2(20),            /*Compound ass                           */
icc74       varchar2(2),             /*Soldering ass                          */
icc75       varchar2(10),            /*Eqa Test Program ass                   */
icc76       varchar2(4),             /*Outline Dimension                      */
icc77       varchar2(20),            /*no use                                 */
icc78       number(15,6),            /*Holding Yield (%) ass                  */
icc79       varchar2(80),            /*ICD Group                              */
iccacti     varchar2(1),             /*资料有效码                             */
iccdate     date,                    /*最近更改日                             */
iccgrup     varchar2(10),            /*资料所有群                             */
iccmodu     varchar2(10),            /*资料更改者                             */
iccuser     varchar2(10),            /*资料所有者                             */
iccud01     varchar2(255),           /*自订字段-Textedit                      */
iccud02     varchar2(40),            /*自订字段-文字                          */
iccud03     varchar2(40),            /*自订字段-文字                          */
iccud04     varchar2(40),            /*自订字段-文字                          */
iccud05     varchar2(40),            /*自订字段-文字                          */
iccud06     varchar2(40),            /*自订字段-文字                          */
iccud07     number(15,3),            /*自订字段-数值                          */
iccud08     number(15,3),            /*自订字段-数值                          */
iccud09     number(15,3),            /*自订字段-数值                          */
iccud10     number(10),              /*自订字段-整数                          */
iccud11     number(10),              /*自订字段-整数                          */
iccud12     number(10),              /*自订字段-整数                          */
iccud13     date,                    /*自订字段-日期                          */
iccud14     date,                    /*自订字段-日期                          */
iccud15     date,                    /*自订字段-日期                          */
iccoriu     varchar2(10),            /*资料建立者                             */
iccorig     varchar2(10)             /*资料建立部门                           */
);

alter table icc_file add  constraint icc_pk primary key  (icc01) enable validate;
grant select on icc_file to tiptopgp;
grant update on icc_file to tiptopgp;
grant delete on icc_file to tiptopgp;
grant insert on icc_file to tiptopgp;
grant index on icc_file to public;
grant select on icc_file to ods;
