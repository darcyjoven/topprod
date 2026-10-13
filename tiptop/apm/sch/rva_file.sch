/*
================================================================================
檔案代號:rva_file
檔案名稱:收货单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rva_file
(
rva01       varchar2(20) NOT NULL,   /*收货单号                               */
                                     /*收貨單號                               */
rva02       varchar2(20),            /*采购单单号                             */
                                     /*採購單單號 pmm01(pmn01)                */
rva03       varchar2(10),            /*优先等级                               */
                                     /*優先等級                               */
rva04       varchar2(2),             /*是否为L/C收料                          */
                                     /*是否為L/C收料                          */
rva05       varchar2(10),            /*供应厂商                               */
                                     /*供应厂商 pmc01                         */
rva06       date,                    /*收货日期                               */
                                     /*收貨日期                               */
rva07       varchar2(20),            /*收货单号                               */
                                     /*收貨單號                               */
                                     /*廠商送貨單號, 可輸入也可不輸入         */
rva08       varchar2(30),            /*进口报单                               */
                                     /*進口報單                               */
rva09       varchar2(16),            /*进口号码                               */
                                     /*進口號碼                               */
rva10       varchar2(10),            /*采购类型                               */
                                     /*採購類別                         (9705)*/
rvaprsw     varchar2(1),             /*是否需打印收货单                       */
                                     /*是否需列印收貨單                       */
rva20       varchar2(1),             /*No Use                                 */
                                     /*NO USE NO:7143                         */
rva21       date,                    /*进口日期                               */
                                     /*進口日期                               */
rva22       varchar2(20),            /*附带打印缺料销单否                     */
                                     /*附帶列印缺料銷單否                     */
rva23       date,                    /*缺料销单截止日期                       */
                                     /*缺料銷單截止日期                       */
rva24       varchar2(15),            /*No Use                                 */
                                     /*no use no.A047                         */
rva25       number(13,3),            /*No Use                                 */
rva26       varchar2(10),            /*异动原因                               */
                                     /*異動原因(保稅用)                       */
rva27       number(8,4),             /*No Use                                 */
rva28       date,                    /*最后打印日期                           */
                                     /*最後列印日期                           */
rva99       varchar2(17),            /*多角贸易流程序号                       */
                                     /*多角貿易流程序號 No.7938 03/08/26 Kammy*/
rvaconf     varchar2(1),             /*资料审核码                             */
                                     /*資料確認碼(Y/N/X) X.作廢               */
rvaprno     number(5),               /*打印次数                               */
                                     /*列印次數                               */
rvaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
rvauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rvagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rvamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rvadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
rvaspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
rva100      varchar2(10),            /*保税异动原因代码                       */
rvaud01     varchar2(255),           /*自订字段-Textedit                      */
rvaud02     varchar2(40),            /*自订字段-文字                          */
rvaud03     varchar2(40),            /*自订字段-文字                          */
rvaud04     varchar2(40),            /*自订字段-文字                          */
rvaud05     varchar2(40),            /*自订字段-文字                          */
rvaud06     varchar2(40),            /*自订字段-文字                          */
rvaud07     number(15,3),            /*自订字段-数值                          */
rvaud08     number(15,3),            /*自订字段-数值                          */
rvaud09     number(15,3),            /*自订字段-数值                          */
rvaud10     number(10),              /*自订字段-整数                          */
rvaud11     number(10),              /*自订字段-整数                          */
rvaud12     number(10),              /*自订字段-整数                          */
rvaud13     date,                    /*自订字段-日期                          */
rvaud14     date,                    /*自订字段-日期                          */
rvaud15     date,                    /*自订字段-日期                          */
rva00       varchar2(1) DEFAULT '1', /*收货类别                               */
rva111      varchar2(10),            /*付款方式                               */
rva112      varchar2(6),             /*价格条件                               */
rva113      varchar2(4),             /*币种                                   */
rva114      number(20,10),           /*汇率                                   */
rva115      varchar2(4),             /*税种                                   */
rva116      number(9,4),             /*税率                                   */
rva117      varchar2(20),            /*VMI发料单号                            */
rva29       varchar2(1) DEFAULT ' ' NOT NULL, /*经营方式 1-经销,2-成本代销,3- */
rva30       varchar2(10),            /*采购营运中心                           */
rva31       varchar2(10),            /*配送中心                               */
rvacond     date,                    /*审核日期                               */
rvaconu     varchar2(10),            /*审核人员                               */
rvacrat     date,                    /*资料创建日                             */
rvaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvalegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvaoriu     varchar2(10),            /*资料建立者                             */
rvaorig     varchar2(10),            /*资料建立部门                           */
rva32       varchar2(1) DEFAULT '0', /*签核状况                               */
rva33       varchar2(10),            /*申请人                                 */
rvamksg     varchar2(1) DEFAULT 'N', /*是否签核                               */
rvacont     varchar2(8),             /*审核时间                               */
rva34       varchar2(20)             /*POS单号                                */
);

create        index rva99 on rva_file (rva99);
create        index rva_03 on rva_file (rva06);
create        index rva_02 on rva_file (rva05);
alter table rva_file add  constraint rva_pk primary key  (rva01) enable validate;
grant select on rva_file to tiptopgp;
grant update on rva_file to tiptopgp;
grant delete on rva_file to tiptopgp;
grant insert on rva_file to tiptopgp;
grant index on rva_file to public;
grant select on rva_file to ods;
