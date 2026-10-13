/*
================================================================================
檔案代號:pna_file
檔案名稱:采购变更单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pna_file
(
pna01       varchar2(20) NOT NULL,   /*采购单号                               */
                                     /*採購單號                               */
pna02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號                               */
pna04       date,                    /*变更日期                               */
                                     /*變更日期                               */
pna05       varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N/X) X.作廢                   */
pna06       varchar2(1),             /*No Use                                 */
pna07       varchar2(1),             /*No Use                                 */
pna08       varchar2(4),             /*变更前币种                             */
                                     /*變更前幣別 #NO:7203                    */
pna08b      varchar2(4),             /*变更后币种                             */
                                     /*變更後幣別 #NO:7203                    */
pna09       varchar2(6),             /*变更前价格条件                         */
                                     /*變更前價格條件 #NO:7203                */
pna09b      varchar2(6),             /*变更后价格条件                         */
                                     /*變更後價格條件 #NO:7203                */
pna10       varchar2(10),            /*变更前付款条件                         */
                                     /*變更前付款條件 #NO:7203                */
pna10b      varchar2(10),            /*变更后付款条件                         */
                                     /*變更後付款條件 #NO:7203                */
pna11       varchar2(10),            /*变更前送货地址                         */
                                     /*變更前送貨地址 #NO:7203                */
pna11b      varchar2(10),            /*变更后送货地址                         */
                                     /*變更後送貨地址 #NO:7203                */
pna12       varchar2(10),            /*变更前发票地址                         */
                                     /*變更前發票地址 #NO:7203                */
pna12b      varchar2(10),            /*变更后发票地址                         */
                                     /*變更後發票地址 #NO:7203                */
pna13       varchar2(1),             /*状况码                                 */
                                     /*狀況碼          No:6686                */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*S: 送簽                                */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
pna14       varchar2(1),             /*签核否                                 */
                                     /*簽核否          No:6686                */
pnaconf     varchar2(1),             /*发出否                                 */
                                     /*發出否(Y/N)                            */
pnaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pnauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pnagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pnamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pnadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pna15       varchar2(10),            /*变更理由码                             */
pnaud01     varchar2(255),           /*自订字段-Textedit                      */
pnaud02     varchar2(40),            /*自订字段-文字                          */
pnaud03     varchar2(40),            /*自订字段-文字                          */
pnaud04     varchar2(40),            /*自订字段-文字                          */
pnaud05     varchar2(40),            /*自订字段-文字                          */
pnaud06     varchar2(40),            /*自订字段-文字                          */
pnaud07     number(15,3),            /*自订字段-数值                          */
pnaud08     number(15,3),            /*自订字段-数值                          */
pnaud09     number(15,3),            /*自订字段-数值                          */
pnaud10     number(10),              /*自订字段-整数                          */
pnaud11     number(10),              /*自订字段-整数                          */
pnaud12     number(10),              /*自订字段-整数                          */
pnaud13     date,                    /*自订字段-日期                          */
pnaud14     date,                    /*自订字段-日期                          */
pnaud15     date,                    /*自订字段-日期                          */
pnaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pnalegal    varchar2(10) NOT NULL,   /*所属法人                               */
pnaoriu     varchar2(10),            /*资料建立者                             */
pnaorig     varchar2(10),            /*资料建立部门                           */
pna16       varchar2(10),            /*变更人员                               */
pna17       varchar2(15),            /*电子变更序号                           */
pnasendd    date,                    /*发出日期                               */
pnasendt    varchar2(8),             /*发出时间                               */
pnasendu    varchar2(10)             /*发出人员                               */
);

alter table pna_file add  constraint pna_pk primary key  (pna01,pna02) enable validate;
grant select on pna_file to tiptopgp;
grant update on pna_file to tiptopgp;
grant delete on pna_file to tiptopgp;
grant insert on pna_file to tiptopgp;
grant index on pna_file to public;
grant select on pna_file to ods;
