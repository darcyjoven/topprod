/*
================================================================================
檔案代號:isa_file
檔案名稱:销项发票底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table isa_file
(
isa00       varchar2(1),             /*资料来源                               */
                                     /*資料來源  0.拋轉  1.人工輸入           */
isa01       varchar2(20) NOT NULL,   /*发票号码                               */
                                     /*發票號碼                               */
isa02       varchar2(20) DEFAULT ' ' NOT NULL, /*发票代码*/
                                     /*發票代碼                               */
isa03       date,                    /*发票日期                               */
                                     /*發票日期                               */
isa04       varchar2(20) NOT NULL,   /*帐款编号                               */
                                     /*帳款編號                               */
isa05       varchar2(10),            /*发票客户编号                           */
                                     /*發票客戶編號                           */
isa051      varchar2(80),            /*发票客户全名                           */
                                     /*發票客戶全名                           */
isa052      varchar2(20),            /*发票客户税号                           */
                                     /*發票客戶統一編號                       */
isa053      varchar2(80),            /*发票客户地址及电话                     */
                                     /*發票客戶地址及電話                     */
isa054      varchar2(80),            /*发票客户银行及帐号                     */
                                     /*發票客戶銀行及帳號                     */
isa06       varchar2(4),             /*税种                                   */
                                     /*稅別                                   */
isa061      number(9,4),             /*营业税率                               */
                                     /*營業稅率   (由稅別檔預設,不可改)       */
isa062      varchar2(1),             /*发票种类                               */
                                     /*發票種類   (由稅別檔預設,不可改)       */
isa07       varchar2(1),             /*状态码                                 */
                                     /*狀態碼                                 */
                                     /* 0.未異動 1.匯出未開票 2.已開發票 V.作廢*/
isa08       number(20,6),            /*发票税前金额                           */
                                     /*發票未稅金額                           */
isa08x      number(20,6),            /*发票税额                               */
                                     /*發票稅額                               */
isa08t      number(20,6),            /*发票含税金额                           */
                                     /*發票含稅金額                           */
isa09       number(5),               /*商品明细行数                           */
                                     /*商品明細行數                           */
isa10       varchar2(255),           /*备注                                   */
isauser     varchar2(10),            /*资料所有者                             */
isagrup     varchar2(10),            /*资料所有部门                           */
isamodu     varchar2(10),            /*资料更改者                             */
isamodd     date,                    /*最近更改日                             */
isadate     date,                    /*资料录入日                             */
isa11       varchar2(10),            /*复核人编号                             */
isa12       varchar2(10),            /*收款人编号                             */
isa13       date,                    /*单据日期                               */
isa14       varchar2(20),            /*销方银行编号                           */
isa15       varchar2(80),            /*销方银行名称加帐号                     */
isaud01     varchar2(255),           /*自订字段-Textedit                      */
isaud02     varchar2(40),            /*自订字段-文字                          */
isaud03     varchar2(40),            /*自订字段-文字                          */
isaud04     varchar2(40),            /*自订字段-文字                          */
isaud05     varchar2(40),            /*自订字段-文字                          */
isaud06     varchar2(40),            /*自订字段-文字                          */
isaud07     number(15,3),            /*自订字段-数值                          */
isaud08     number(15,3),            /*自订字段-数值                          */
isaud09     number(15,3),            /*自订字段-数值                          */
isaud10     number(10),              /*自订字段-整数                          */
isaud11     number(10),              /*自订字段-整数                          */
isaud12     number(10),              /*自订字段-整数                          */
isaud13     date,                    /*自订字段-日期                          */
isaud14     date,                    /*自订字段-日期                          */
isaud15     date,                    /*自订字段-日期                          */
isalegal    varchar2(10) NOT NULL,   /*所属法人                               */
isaoriu     varchar2(10),            /*资料建立者                             */
isaorig     varchar2(10)             /*资料建立部门                           */
);

alter table isa_file add  constraint isa_pk primary key  (isa01,isa02,isa04) enable validate;
grant select on isa_file to tiptopgp;
grant update on isa_file to tiptopgp;
grant delete on isa_file to tiptopgp;
grant insert on isa_file to tiptopgp;
grant index on isa_file to public;
grant select on isa_file to ods;
