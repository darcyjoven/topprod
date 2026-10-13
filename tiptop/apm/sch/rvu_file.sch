/*
================================================================================
檔案代號:rvu_file
檔案名稱:入库/退扣单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvu_file
(
rvu00       varchar2(1),             /*异动类型                               */
                                     /*異動類別(1.入庫2.驗退3.倉退)           */
rvu01       varchar2(20) NOT NULL,   /*入库单号/退货单号                      */
                                     /*入庫單號/退貨單號                      */
rvu02       varchar2(20),            /*收货单号                               */
                                     /*收貨單號 rva01(rvb01)                  */
rvu03       date,                    /*异动日期                               */
                                     /*異動日期                               */
rvu04       varchar2(10),            /*厂商编号                               */
                                     /*廠商編號 pmc01                         */
rvu05       varchar2(40),            /*厂商简称                               */
                                     /*廠商簡稱                               */
rvu06       varchar2(10),            /*部门                                   */
                                     /*部門     gem01                         */
rvu07       varchar2(10),            /*人员                                   */
                                     /*人員     gen01                         */
rvu08       varchar2(10),            /*采购性质                               */
                                     /*採購性質                               */
rvu09       date,                    /*取回日期                               */
rvu10       varchar2(1),             /*开立折让单否                           */
                                     /*開立折讓單否(Y/N)(退貨單使用)          */
rvu11       date,                    /*折让单日期                             */
                                     /*折讓單日期       (退貨單使用)          */
rvu12       number(9,4),             /*税率                                   */
                                     /*稅率             (退貨單使用)          */
rvu13       number(20,6),            /*折让单税前金额                         */
                                     /*折讓單未稅金額   (退貨單使用)          */
rvu14       number(20,6),            /*折让单税额                             */
                                     /*折讓單稅額       (退貨單使用)          */
rvu15       varchar2(20),            /*折让原发票号                           */
                                     /*折讓原發票號     (退貨單使用)          */
rvu20       varchar2(1),             /*多角贸易抛转否                         */
                                     /*多角貿易拋轉否   add 02/02/18          */
rvu99       varchar2(17),            /*多角贸易流程序号                       */
                                     /*多角貿易流程序號 No.7944 03/08/26 Kammy*/
rvuconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X) X.作廢                   */
rvuacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
rvuuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rvugrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rvumodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rvudate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
rvu100      varchar2(10),            /*保税异动原因代码                       */
rvu101      varchar2(30),            /*保税进口报单                           */
rvu102      date,                    /*保税进口报单日期                       */
rvuud01     varchar2(255),           /*自订字段-Textedit                      */
rvuud02     varchar2(40),            /*自订字段-文字                          */
rvuud03     varchar2(40),            /*自订字段-文字                          */
rvuud04     varchar2(40),            /*自订字段-文字                          */
rvuud05     varchar2(40),            /*自订字段-文字                          */
rvuud06     varchar2(40),            /*自订字段-文字                          */
rvuud07     number(15,3),            /*自订字段-数值                          */
rvuud08     number(15,3),            /*自订字段-数值                          */
rvuud09     number(15,3),            /*自订字段-数值                          */
rvuud10     number(10),              /*自订字段-整数                          */
rvuud11     number(10),              /*自订字段-整数                          */
rvuud12     number(10),              /*自订字段-整数                          */
rvuud13     date,                    /*自订字段-日期                          */
rvuud14     date,                    /*自订字段-日期                          */
rvuud15     date,                    /*自订字段-日期                          */
rvu16       varchar2(20),            /*领料单号                               */
rvu111      varchar2(10),            /*付款方式                               */
rvu112      varchar2(6),             /*价格条件                               */
rvu113      varchar2(4),             /*币种                                   */
rvu115      varchar2(4),             /*税种                                   */
rvu116      varchar2(1),             /*退货方式                               */
rvu117      varchar2(20),            /*VMI发/退料单号                         */
rvu114      number(20,10),           /*汇率                                   */
rvu21       varchar2(1) DEFAULT ' ' NOT NULL, /*经营方式 1-经销,2-成本代销;3- */
rvu22       varchar2(10),            /*采购营运中心                           */
rvu23       varchar2(10),            /*配送中心                               */
rvu24       varchar2(8),             /*多角贸易流程代码                       */
rvu900      varchar2(1) DEFAULT '0' NOT NULL, /*状况码:0.开立(Open)1.已核准9.作*/
rvucond     date,                    /*审核日期                               */
rvucont     varchar2(8),             /*审核时间                               */
rvuconu     varchar2(10),            /*审核人员                               */
rvucrat     date,                    /*资料创建日                             */
rvudays     number(5),               /*签核完成天数                           */
rvumksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
rvuprit     number(5),               /*签核优先等级                           */
rvusign     varchar2(4),             /*签核等级                               */
rvusmax     number(5),               /*应签核顺序                             */
rvusseq     number(5),               /*已签核顺序                             */
rvupos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
rvuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvulegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvuoriu     varchar2(10),            /*资料建立者                             */
rvuorig     varchar2(10),            /*资料建立部门                           */
rvu25       varchar2(20),            /*来源单号                               */
rvu17       varchar2(1) DEFAULT '0' NOT NULL, /*签核状况*/
rvu26       varchar2(20),            /*申请单号                               */
rvu27       varchar2(1) DEFAULT ' ' NOT NULL /*虛擬類型*/
);

create        index rvu_03 on rvu_file (rvu02);
create        index rvu_02 on rvu_file (rvu00,rvu01);
alter table rvu_file add  constraint rvu_pk primary key  (rvu01) enable validate;
grant select on rvu_file to tiptopgp;
grant update on rvu_file to tiptopgp;
grant delete on rvu_file to tiptopgp;
grant insert on rvu_file to tiptopgp;
grant index on rvu_file to public;
grant select on rvu_file to ods;
