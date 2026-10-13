/*
================================================================================
檔案代號:ise_file
檔案名稱:进项发票底稿档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ise_file
(
ise00       varchar2(1),             /*资料来源                               */
                                     /*資料來源  0.拋轉  2.人工輸入           */
ise01       varchar2(20) NOT NULL,   /*发票号码                               */
                                     /*發票號碼                               */
ise02       varchar2(20),            /*发票代码                               */
                                     /*發票代碼                               */
ise03       date,                    /*发票日期                               */
                                     /*發票日期                               */
ise04       varchar2(20) NOT NULL,   /*帐款编号                               */
                                     /*帳款編號                               */
ise05       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ise051      varchar2(20),            /*厂商税号                               */
                                     /*廠商統一編號                           */
ise052      varchar2(80),            /*厂商全名                               */
                                     /*廠商全名                               */
ise06       varchar2(4),             /*税种                                   */
                                     /*稅別                                   */
ise061      number(9,4),             /*营业税率                               */
                                     /*營業稅率   (稅別檔預設, 不可改)        */
ise062      varchar2(1),             /*发票种类                               */
                                     /*發票種類   (稅別檔預設, 不可改)        */
                                     /*A.農產品收購憑證 G.海關代徵完稅憑證    */
                                     /*N.不可抵扣專用發票 S.可抵扣專用發票    */
                                     /*T.運輸發票 W.廢舊物資收購憑證 Z.其他   */
ise07       varchar2(1),             /*状态码                                 */
                                     /*狀態碼  0.未匯出  1.已匯出             */
ise08       number(20,6),            /*发票税前金额                           */
                                     /*發票未稅金額                           */
ise08x      number(20,6),            /*发票税额                               */
                                     /*發票稅額                               */
ise08t      number(20,6),            /*发票含税金额                           */
                                     /*發票含稅金額                           */
ise09       date,                    /*入库日期                               */
                                     /*入庫日期                               */
ise10       varchar2(5),             /*凭证序号                               */
                                     /*憑證序號                               */
ise11       varchar2(20),            /*付款单号                               */
                                     /*付款單號                               */
ise12       date,                    /*付款日期                               */
ise13       number(20,6),            /*付款金额                               */
                                     /*付款金額                               */
ise14       varchar2(80),            /*货物名称                               */
                                     /*貨物名稱                               */
ise15       number(15,3),            /*数量                                   */
                                     /*數量                                   */
ise16       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
ise17       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ise18       varchar2(20),            /*异动单号                               */
                                     /*異動單號                               */
ise19       number(5),               /*项次                                   */
                                     /*項次                                   */
ise20       varchar2(1),             /*No Use                                 */
iseuser     varchar2(10),            /*资料所有者                             */
isegrup     varchar2(10),            /*资料所有部门                           */
isemodu     varchar2(10),            /*资料更改者                             */
isemodd     date,                    /*最近更改日                             */
isedate     date,                    /*资料录入日                             */
iseud01     varchar2(255),           /*自订字段-Textedit                      */
iseud02     varchar2(40),            /*自订字段-文字                          */
iseud03     varchar2(40),            /*自订字段-文字                          */
iseud04     varchar2(40),            /*自订字段-文字                          */
iseud05     varchar2(40),            /*自订字段-文字                          */
iseud06     varchar2(40),            /*自订字段-文字                          */
iseud07     number(15,3),            /*自订字段-数值                          */
iseud08     number(15,3),            /*自订字段-数值                          */
iseud09     number(15,3),            /*自订字段-数值                          */
iseud10     number(10),              /*自订字段-整数                          */
iseud11     number(10),              /*自订字段-整数                          */
iseud12     number(10),              /*自订字段-整数                          */
iseud13     date,                    /*自订字段-日期                          */
iseud14     date,                    /*自订字段-日期                          */
iseud15     date,                    /*自订字段-日期                          */
iselegal    varchar2(10) NOT NULL,   /*所属法人                               */
iseoriu     varchar2(10),            /*资料建立者                             */
iseorig     varchar2(10)             /*资料建立部门                           */
);

alter table ise_file add  constraint ise_pk primary key  (ise01,ise04,ise05) enable validate;
grant select on ise_file to tiptopgp;
grant update on ise_file to tiptopgp;
grant delete on ise_file to tiptopgp;
grant insert on ise_file to tiptopgp;
grant index on ise_file to public;
grant select on ise_file to ods;
