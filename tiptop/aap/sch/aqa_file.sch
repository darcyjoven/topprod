/*
================================================================================
檔案代號:aqa_file
檔案名稱:应付账款分摊费用单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aqa_file
(
aqa01       varchar2(20) NOT NULL,   /*分摊费用单号                           */
                                     /*分攤費用單號                           */
aqa02       date,                    /*分摊日期                               */
                                     /*分攤日期                               */
aqa03       number(20,6),            /*分摊总金额                             */
                                     /*分攤總金額(未稅)                       */
aqa04       varchar2(1),             /*分摊码                                 */
                                     /*是否已分攤(Y/N)                        */
aqa05       varchar2(20),            /*已抛转总帐之凭证号码                   */
                                     /*已拋轉總帳之傳票號碼                   */
aqaconf     varchar2(1),             /*确认码                                 */
aqainpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
aqaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
aqauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
aqagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
aqamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
aqadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
aqaud01     varchar2(255),           /*自订字段-Textedit                      */
aqaud02     varchar2(40),            /*自订字段-文字                          */
aqaud03     varchar2(40),            /*自订字段-文字                          */
aqaud04     varchar2(40),            /*自订字段-文字                          */
aqaud05     varchar2(40),            /*自订字段-文字                          */
aqaud06     varchar2(40),            /*自订字段-文字                          */
aqaud07     number(15,3),            /*自订字段-数值                          */
aqaud08     number(15,3),            /*自订字段-数值                          */
aqaud09     number(15,3),            /*自订字段-数值                          */
aqaud10     number(10),              /*自订字段-整数                          */
aqaud11     number(10),              /*自订字段-整数                          */
aqaud12     number(10),              /*自订字段-整数                          */
aqaud13     date,                    /*自订字段-日期                          */
aqaud14     date,                    /*自订字段-日期                          */
aqaud15     date,                    /*自订字段-日期                          */
aqalegal    varchar2(10) NOT NULL,   /*所属法人                               */
aqaoriu     varchar2(10),            /*资料建立者                             */
aqaorig     varchar2(10),            /*资料建立部门                           */
aqa00       varchar2(1) DEFAULT ' ' NOT NULL /*类型*/
);

alter table aqa_file add  constraint aqa_pk primary key  (aqa01) enable validate;
grant select on aqa_file to tiptopgp;
grant update on aqa_file to tiptopgp;
grant delete on aqa_file to tiptopgp;
grant insert on aqa_file to tiptopgp;
grant index on aqa_file to public;
grant select on aqa_file to ods;
