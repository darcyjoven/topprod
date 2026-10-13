/*
================================================================================
檔案代號:poz_file
檔案名稱:多角贸易流程代码设定单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table poz_file
(
poz00       varchar2(1),             /*1.销售段 2.代采购                      */
                                     /*1.銷售段 2.代採購                      */
poz01       varchar2(8) NOT NULL,    /*流程代码                               */
                                     /*流程代碼                               */
poz011      varchar2(1),             /*1.正抛 2.逆抛                          */
                                     /*1.Forward 2.Backward                   */
                                     /*Sales Section︰Forward->Delivery From Origination DB Backward->Delivery From Final DB*/
                                     /*Sub PO︰Forward->Goods Receipt Srore-in From Origination DB Backward->Delivery From Final DB*/
poz02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
poz03       varchar2(1),             /*营业额申报方式                         */
                                     /*營業額申報方式                         */
                                     /*1.全額申報 2.差額申報 3.不申報         */
poz04       varchar2(10),            /*来源客户编号                           */
                                     /*來源客戶編號                           */
poz05       varchar2(10),            /*来源营运中心编号                       */
                                     /*來源工廠編號                           */
poz06       varchar2(10),            /*AR科目类型                             */
                                     /*AR科目類別(來源工廠) -->銷售段         */
                                     /*AP科目類別(來源工廠) -->代採購         */
poz07       varchar2(10),            /*AR部门                                 */
                                     /*AR部門(來源工廠)-->銷售段              */
                                     /*AP部門(來源工廠)-->代採購              */
poz08       varchar2(4),             /*No Use                                 */
poz09       varchar2(1),             /*指定币种否                             */
                                     /*指定幣別否                             */
                                     /*Y.使用指定幣別  N.使用來源幣別         */
poz10       varchar2(1),             /*抛转订单 Memo 资料否                   */
                                     /*拋轉訂單 Memo 資料否                   */
poz11       varchar2(1),             /*流程序号编号方式                       */
                                     /*Flow S/N Numbering Method (1.S/N 2.By YY/MM)*/
poz12       varchar2(1) DEFAULT ' ', /*两角内部交易否                         */
poz13       varchar2(10) DEFAULT ' ',/*来源营运中心                           */
poz14       varchar2(10) DEFAULT ' ',/*目的营运中心                           */
poz15       varchar2(1),             /*No Use                                 */
poz16       varchar2(1),             /*No Use                                 */
pozacti     varchar2(1),             /*资料有效码                             */
pozuser     varchar2(10),            /*资料所有者                             */
pozgrup     varchar2(10),            /*资料所有群                             */
pozmodu     varchar2(10),            /*资料更改者                             */
pozdate     date,                    /*最近更改日                             */
poz17       varchar2(1),             /*流程是否要一次性完成                   */
poz18       varchar2(10),            /*中断营运中心                           */
poz19       varchar2(1),             /*抛转中断否                             */
pozud01     varchar2(255),           /*自订字段-Textedit                      */
pozud02     varchar2(40),            /*自订字段-文字                          */
pozud03     varchar2(40),            /*自订字段-文字                          */
pozud04     varchar2(40),            /*自订字段-文字                          */
pozud05     varchar2(40),            /*自订字段-文字                          */
pozud06     varchar2(40),            /*自订字段-文字                          */
pozud07     number(15,3),            /*自订字段-数值                          */
pozud08     number(15,3),            /*自订字段-数值                          */
pozud09     number(15,3),            /*自订字段-数值                          */
pozud10     number(10),              /*自订字段-整数                          */
pozud11     number(10),              /*自订字段-整数                          */
pozud12     number(10),              /*自订字段-整数                          */
pozud13     date,                    /*自订字段-日期                          */
pozud14     date,                    /*自订字段-日期                          */
pozud15     date,                    /*自订字段-日期                          */
poz20       varchar2(1) DEFAULT 'N' NOT NULL, /*是否模板*/
poz21       varchar2(8),             /*来源模板                               */
pozoriu     varchar2(10),            /*资料建立者                             */
pozorig     varchar2(10)             /*资料建立部门                           */
);

alter table poz_file add  constraint poz_pk primary key  (poz01) enable validate;
grant select on poz_file to tiptopgp;
grant update on poz_file to tiptopgp;
grant delete on poz_file to tiptopgp;
grant insert on poz_file to tiptopgp;
grant index on poz_file to public;
grant select on poz_file to ods;
