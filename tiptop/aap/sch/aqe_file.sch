/*
================================================================================
檔案代號:aqe_file
檔案名稱:集团代付冲账单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aqe_file
(
aqe00       varchar2(1) NOT NULL,    /*代收付类型                             */
                                     /*For 內部帳戶                           */
aqe01       varchar2(20) NOT NULL,   /*集团代收付单号                         */
                                     /*For 內部帳戶                           */
aqe02       date,                    /*代收付款日期                           */
                                     /*For 內部帳戶                           */
aqe03       varchar2(10),            /*厂商/客户代码                          */
                                     /*For 內部帳戶                           */
aqe04       varchar2(10),            /*人员                                   */
                                     /*For 內部帳戶                           */
aqe05       varchar2(10),            /*部门                                   */
                                     /*For 內部帳戶                           */
aqe06       varchar2(4),             /*币种                                   */
                                     /*For 內部帳戶                           */
aqe07       number(20,10),           /*汇率                                   */
                                     /*For 內部帳戶                           */
aqe08       number(20,6),            /*本币帐款金额                           */
                                     /*For 內部帳戶                           */
aqe08f      number(20,6),            /*原币帐款金额                           */
                                     /*For 內部帳戶                           */
aqe09       number(20,6),            /*本币代收付款金额                       */
                                     /*For 內部帳戶                           */
aqe09f      number(20,6),            /*原币代收付款金额                       */
                                     /*For 內部帳戶                           */
aqe10       varchar2(10),            /*代收付款理由                           */
                                     /*For 內部帳戶                           */
aqe11       varchar2(40),            /*客户简称/厂商简称                      */
                                     /*For 內部帳戶                           */
aqe12       varchar2(20),            /*所属营运中心                           */
                                     /*For 內部帳戶                           */
aqe13       varchar2(10),            /*现金变动别                             */
                                     /*For 內部帳戶                           */
aqe14       varchar2(1),             /*确认码                                 */
                                     /*For 內部帳戶                           */
aqe15       varchar2(1),             /*状况码                                 */
                                     /*For 內部帳戶                           */
aqeinpd     date,                    /*录入日期                               */
                                     /*For 內部帳戶                           */
aqemksg     varchar2(1),             /*是否签核                               */
                                     /*For 內部帳戶                           */
aqesign     varchar2(4),             /*签核等级                               */
                                     /*For 內部帳戶                           */
aqedays     number(5),               /*签核完成天数                           */
                                     /*For 內部帳戶                           */
aqeprit     number(5),               /*签核优先等级                           */
                                     /*For 內部帳戶                           */
aqesmax     number(5),               /*应签等级                               */
                                     /*For 內部帳戶                           */
aqesseq     number(5),               /*已签等级                               */
                                     /*For 內部帳戶                           */
aqeprno     number(5),               /*打印次数                               */
                                     /*For 內部帳戶                           */
aqeacti     varchar2(1),             /*资料有效码                             */
                                     /*For 內部帳戶                           */
aqeuser     varchar2(10),            /*资料所有者                             */
                                     /*For 內部帳戶                           */
aqegrup     varchar2(10),            /*资料所有部门                           */
                                     /*For 內部帳戶                           */
aqemodu     varchar2(10),            /*资料更改者                             */
                                     /*For 內部帳戶                           */
aqedate     date,                    /*最后更改日期                           */
                                     /*For 內部帳戶                           */
aqeud01     varchar2(255),           /*自订字段-Textedit                      */
aqeud02     varchar2(40),            /*自订字段-文字                          */
aqeud03     varchar2(40),            /*自订字段-文字                          */
aqeud04     varchar2(40),            /*自订字段-文字                          */
aqeud05     varchar2(40),            /*自订字段-文字                          */
aqeud06     varchar2(40),            /*自订字段-文字                          */
aqeud07     number(15,3),            /*自订字段-数值                          */
aqeud08     number(15,3),            /*自订字段-数值                          */
aqeud09     number(15,3),            /*自订字段-数值                          */
aqeud10     number(10),              /*自订字段-整数                          */
aqeud11     number(10),              /*自订字段-整数                          */
aqeud12     number(10),              /*自订字段-整数                          */
aqeud13     date,                    /*自订字段-日期                          */
aqeud14     date,                    /*自订字段-日期                          */
aqeud15     date,                    /*自订字段-日期                          */
aqelegal    varchar2(10) NOT NULL,   /*所属法人                               */
aqeoriu     varchar2(10),            /*资料建立者                             */
aqeorig     varchar2(10)             /*资料建立部门                           */
);

alter table aqe_file add  constraint aqe_pk primary key  (aqe01) enable validate;
grant select on aqe_file to tiptopgp;
grant update on aqe_file to tiptopgp;
grant delete on aqe_file to tiptopgp;
grant insert on aqe_file to tiptopgp;
grant index on aqe_file to public;
grant select on aqe_file to ods;
