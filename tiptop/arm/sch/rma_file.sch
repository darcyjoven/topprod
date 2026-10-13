/*
================================================================================
檔案代號:rma_file
檔案名稱:RMA 单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rma_file
(
rma01       varchar2(20) NOT NULL,   /*RMA 单号                               */
                                     /*RMA 單號                               */
rma02       date,                    /*登记日期                               */
                                     /*登記日期                               */
rma03       varchar2(10),            /*退货客户编号                           */
                                     /*退貨客戶編號                           */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
rma04       varchar2(40),            /*退货客户简称                           */
                                     /*退貨客戶簡稱                           */
rma05       varchar2(20),            /*退货客户税号                           */
                                     /*退貨客戶統一編號                       */
rma06       date,                    /*预计到货日期                           */
                                     /*預計到貨日期                           */
rma07       date,                    /*单据登录日期                           */
                                     /*單據登錄日期                           */
rma08       varchar2(1),             /*1.内销 2.外销                          */
                                     /*1.內銷 2.外銷                          */
rma09       varchar2(1),             /*RMA 处理方式                           */
                                     /*RMA 處理方式                           */
                                     /*  6.取消                               */
rma10       varchar2(30),            /*进口报单                               */
                                     /*進口報單(參考用)                       */
rma11       varchar2(10),            /*进口方式                               */
                                     /*進口方式(參考用)                       */
rma12       date,                    /*预计覆出日期                           */
                                     /*預計覆出日期                           */
rma13       varchar2(10),            /*人员编号                               */
                                     /*人員編號                               */
rma14       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
rma15       varchar2(10),            /*No Use                                 */
rma16       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
rma17       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
rma18       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
rma19       date,                    /*结案日期                               */
                                     /*結案日期                               */
rma20       date,                    /*实际收货日期                           */
                                     /*實際收貨日期(到廠日期)                 */
rma21       date,                    /*点收日期                               */
                                     /*點收日期                               */
rma22       varchar2(20),            /*客诉单号                               */
                                     /*客訴單號                            養生*/
rmarecv     varchar2(1),             /*点收审核否                             */
                                     /*t150:點收確認否(/Y/N)                  */
rmaconf     varchar2(1),             /*审核否                                 */
                                     /*t110:確認否 (Y/N)                      */
rmavoid     varchar2(1),             /*有效否                                 */
                                     /*有效否 (Y/N) Y:有效 N:作廢             */
rmauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rmagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rmamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rmadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
rmaud01     varchar2(255),           /*自订字段-Textedit                      */
rmaud02     varchar2(40),            /*自订字段-文字                          */
rmaud03     varchar2(40),            /*自订字段-文字                          */
rmaud04     varchar2(40),            /*自订字段-文字                          */
rmaud05     varchar2(40),            /*自订字段-文字                          */
rmaud06     varchar2(40),            /*自订字段-文字                          */
rmaud07     number(15,3),            /*自订字段-数值                          */
rmaud08     number(15,3),            /*自订字段-数值                          */
rmaud09     number(15,3),            /*自订字段-数值                          */
rmaud10     number(10),              /*自订字段-整数                          */
rmaud11     number(10),              /*自订字段-整数                          */
rmaud12     number(10),              /*自订字段-整数                          */
rmaud13     date,                    /*自订字段-日期                          */
rmaud14     date,                    /*自订字段-日期                          */
rmaud15     date,                    /*自订字段-日期                          */
rmaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmalegal    varchar2(10) NOT NULL,   /*所属法人                               */
rmaoriu     varchar2(10),            /*资料建立者                             */
rmaorig     varchar2(10),            /*资料建立部门                           */
rma23       varchar2(40)             /*客戶電話                               */
);

alter table rma_file add  constraint rma_pk primary key  (rma01) enable validate;
grant select on rma_file to tiptopgp;
grant update on rma_file to tiptopgp;
grant delete on rma_file to tiptopgp;
grant insert on rma_file to tiptopgp;
grant index on rma_file to public;
grant select on rma_file to ods;
