/*
================================================================================
檔案代號:olc_file
檔案名稱:销售信用状押汇档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table olc_file
(
olc01       varchar2(20) NOT NULL,   /*Invoice No.                            */
                                     /*INVOICE#                               */
olc02       date,                    /*出货日期                               */
                                     /*出貨日期                               */
olc03       varchar2(1),             /*1.内销 2.外销                          */
                                     /*1.內銷 2.外銷                          */
olc04       varchar2(20),            /*L/C No.                                */
olc05       varchar2(10),            /*客户                                   */
                                     /*客戶                                   */
olc06       varchar2(6),             /*收款条件                               */
                                     /*收款條件                               */
olc07       date,                    /*最后装船日                             */
                                     /*最後裝船日                             */
olc08       date,                    /*有效日期                               */
olc09       number(20,6) NOT NULL,   /*出货金额                               */
                                     /*出貨金額                               */
olc10       number(20,6) NOT NULL,   /*其他金额                               */
                                     /*其他金額                               */
olc11       number(20,6) NOT NULL,   /*押汇金额                               */
                                     /*押匯金額                               */
olc12       date,                    /*押汇日期                               */
                                     /*押匯日期                               */
olc13       varchar2(20),            /*押汇银行                               */
                                     /*押匯銀行                               */
olc141      varchar2(255),           /*不能押汇原因一                         */
                                     /*不能押匯原因一                    genero*/
olc142      varchar2(255),           /*不能押汇原因二                         */
                                     /*no use                            genero*/
olc15       date,                    /*付款/承兑书收到日期                    */
                                     /*付款/承兌書收到日期                    */
olc16       date,                    /*空运提单收到日期                       */
                                     /*空運提單收到日期                       */
olc17       date,                    /*收货报告书收到日期                     */
                                     /*收貨報告書收到日期                     */
olc18       date,                    /*验收单收到日期                         */
                                     /*驗收單收到日期                         */
olc19       date,                    /*承兑日期                               */
                                     /*承兌日期                               */
olc20       date,                    /*汇入日期                               */
                                     /*匯入日期                               */
olc21       varchar2(1),             /*No Use                                 */
olc22       varchar2(1),             /*No Use                                 */
olc23       varchar2(20),            /*凭证单号                               */
                                     /*傳票單號   (99/05/11)                  */
olc24       date,                    /*凭证日期                               */
                                     /*傳票日期   (99/05/21)                  */
olc25       varchar2(1),             /*No Use                                 */
olc26       varchar2(1),             /*No Use                                 */
olc27       varchar2(1),             /*No Use                                 */
olc28       number(5),               /*次数                                   */
                                     /*次數       (99/05/11)                  */
olc29       varchar2(20),            /*收状单号                               */
                                     /*收狀單號   (99/05/11)                  */
olc30       varchar2(10),            /*审核者                                 */
                                     /*確認者                                 */
olcconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N)                           */
olcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
olcgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
olcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
olcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
olc31       varchar2(10),            /*出货来源营运中心代码                   */
olc32       varchar2(10),            /*部门                                   */
olc930      varchar2(10),            /*成本中心                               */
olcud01     varchar2(255),           /*自订字段-Textedit                      */
olcud02     varchar2(40),            /*自订字段-文字                          */
olcud03     varchar2(40),            /*自订字段-文字                          */
olcud04     varchar2(40),            /*自订字段-文字                          */
olcud05     varchar2(40),            /*自订字段-文字                          */
olcud06     varchar2(40),            /*自订字段-文字                          */
olcud07     number(15,3),            /*自订字段-数值                          */
olcud08     number(15,3),            /*自订字段-数值                          */
olcud09     number(15,3),            /*自订字段-数值                          */
olcud10     number(10),              /*自订字段-整数                          */
olcud11     number(10),              /*自订字段-整数                          */
olcud12     number(10),              /*自订字段-整数                          */
olcud13     date,                    /*自订字段-日期                          */
olcud14     date,                    /*自订字段-日期                          */
olcud15     date,                    /*自订字段-日期                          */
olclegal    varchar2(10) NOT NULL,   /*所属法人                               */
olcoriu     varchar2(10),            /*资料建立者                             */
olcorig     varchar2(10)             /*资料建立部门                           */
);

create        index olc_02 on olc_file (olc23);
alter table olc_file add  constraint olc_pk primary key  (olc01) enable validate;
grant select on olc_file to tiptopgp;
grant update on olc_file to tiptopgp;
grant delete on olc_file to tiptopgp;
grant insert on olc_file to tiptopgp;
grant index on olc_file to public;
grant select on olc_file to ods;
