/*
================================================================================
檔案代號:ohc_file
檔案名稱:客诉处理单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ohc_file
(
ohc01       varchar2(20) NOT NULL,   /*客诉单号                               */
                                     /*客訴單號                               */
ohc02       date,                    /*客诉日期                               */
                                     /*客訴日期                               */
ohc03       varchar2(1),             /*当前状态                               */
                                     /*目前狀態                               */
                                     /*'0':未處理                             */
                                     /*'1':處理中                             */
                                     /*'2':結案                               */
ohc04       varchar2(20),            /*原出货单号                             */
                                     /*原出貨單號                             */
ohc041      number(5),               /*原出货单项次                           */
                                     /*原出貨單項次                           */
ohc05       date,                    /*原销货日期                             */
                                     /*原銷貨日期                             */
ohc06       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
ohc061      varchar2(40),            /*客户简称                               */
                                     /*客戶簡稱                               */
ohc07       varchar2(20),            /*发票号码                               */
                                     /*發票號碼                               */
ohc08       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
ohc081      varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
ohc09       varchar2(20),            /*客户订单                               */
                                     /*客戶訂單                               */
ohc10       varchar2(10),            /*负责业务                               */
                                     /*負責業務                               */
ohc11       varchar2(10),            /*处理人员                               */
                                     /*處理人員                               */
ohc12       varchar2(1),             /*No Use                                 */
ohc13       date,                    /*处理期限                               */
                                     /*處理期限                               */
ohc14       date,                    /*结案日期                               */
                                     /*結案日期                               */
ohc15       varchar2(4),             /*币种                                   */
                                     /*幣別      azi01                        */
ohc16       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
ohc17       number(20,6),            /*单价                                   */
                                     /*單價                                   */
ohc18       number(15,3),            /*客诉数量                               */
                                     /*客訴數量                               */
ohc181      number(15,3),            /*补货数量                               */
                                     /*補貨數量                               */
ohc182      number(15,3),            /*换货数量                               */
                                     /*換貨數量                               */
ohc183      number(15,3),            /*销货退回                               */
                                     /*銷貨退回                               */
ohc184      number(20,6),            /*折让金额                               */
                                     /*折讓金額                               */
ohc19       varchar2(1),             /*No Use                                 */
ohc20       varchar2(1),             /*No Use                                 */
ohc21       varchar2(1),             /*No Use                                 */
ohc22       varchar2(1),             /*No Use                                 */
ohc23       varchar2(1),             /*No Use                                 */
ohc24       varchar2(1),             /*No Use                                 */
ohc25       varchar2(1),             /*No Use                                 */
ohcconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N/X)                         */
ohcuser     varchar2(10),            /*资料所有者                             */
ohcgrup     varchar2(10),            /*资料所有部门                           */
ohcmodu     varchar2(10),            /*资料更改者                             */
ohcdate     date,                    /*最近更改日                             */
ohcud01     varchar2(255),           /*自订字段-Textedit                      */
ohcud02     varchar2(40),            /*自订字段-文字                          */
ohcud03     varchar2(40),            /*自订字段-文字                          */
ohcud04     varchar2(40),            /*自订字段-文字                          */
ohcud05     varchar2(40),            /*自订字段-文字                          */
ohcud06     varchar2(40),            /*自订字段-文字                          */
ohcud07     number(15,3),            /*自订字段-数值                          */
ohcud08     number(15,3),            /*自订字段-数值                          */
ohcud09     number(15,3),            /*自订字段-数值                          */
ohcud10     number(10),              /*自订字段-整数                          */
ohcud11     number(10),              /*自订字段-整数                          */
ohcud12     number(10),              /*自订字段-整数                          */
ohcud13     date,                    /*自订字段-日期                          */
ohcud14     date,                    /*自订字段-日期                          */
ohcud15     date,                    /*自订字段-日期                          */
ohcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ohclegal    varchar2(10) NOT NULL,   /*所属法人                               */
ohcoriu     varchar2(10),            /*资料建立者                             */
ohcorig     varchar2(10)             /*资料建立部门                           */
);

alter table ohc_file add  constraint ohc_pk primary key  (ohc01) enable validate;
grant select on ohc_file to tiptopgp;
grant update on ohc_file to tiptopgp;
grant delete on ohc_file to tiptopgp;
grant insert on ohc_file to tiptopgp;
grant index on ohc_file to public;
grant select on ohc_file to ods;
