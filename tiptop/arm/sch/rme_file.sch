/*
================================================================================
檔案代號:rme_file
檔案名稱:RMA 覆出单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rme_file
(
rme01       varchar2(20) NOT NULL,   /*RMA覆出单号                            */
                                     /*RMA覆出單號                            */
rme011      varchar2(20),            /*RMA单号                                */
                                     /*RMA單號                                */
rme02       date,                    /*单据日期                               */
                                     /*單據日期                               */
rme021      date,                    /*覆出日期                               */
rme03       varchar2(10),            /*退货客户编号                           */
                                     /*退貨客戶編號                           */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
rme04       varchar2(40),            /*退货客户简称                           */
                                     /*退貨客戶簡稱                           */
rme041      varchar2(20),            /*退货客户税号                           */
                                     /*退貨客戶統一編號                       */
rme071      varchar2(80),            /*退货客户全名                           */
                                     /*退貨客戶全名(同 occ18 公司全名-1)      */
rme072      varchar2(80),            /*退货客户全名                           */
                                     /*退貨客戶全名(同 occ19 公司全名-2)      */
rme073      varchar2(255),           /*送货地址                               */
                                     /*送貨地址                               */
rme074      varchar2(255),           /*送货地址                               */
                                     /*送貨地址                               */
rme075      varchar2(255),           /*送货地址                               */
                                     /*送貨地址                               */
rme08       varchar2(20),            /*发票编号/统一发票号码                  */
                                     /*發票編號/統一發票號碼                  */
rme09       varchar2(30),            /*报关单号                               */
                                     /*報關單號                               */
rme10       varchar2(20),            /*应收帐款立帐单编号                     */
                                     /*應收帳款立帳單編號(oma_file)           */
rme11       date,                    /*报关日期                               */
                                     /*報關日期                               */
rme12       varchar2(10),            /*人员编号                               */
                                     /*人員編號                               */
rme13       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
rme15       varchar2(4),             /*税种                                   */
                                     /*稅別                                   */
rme151      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改)           */
rme152      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改)           */
rme153      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)           */
rme16       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
rme17       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
rme18       number(20,6),            /*原币应收税前金额                       */
                                     /*原幣應收未稅金額                       */
rme181      number(20,6),            /*原币应收税额                           */
                                     /*原幣應收稅額                           */
rme182      number(20,6),            /*原币应收含税金额                       */
                                     /*原幣應收含稅金額                       */
rme19       number(20,6),            /*原币立帐税前金额                       */
                                     /*原幣立帳未稅金額                       */
rme191      number(20,6),            /*原币立帐税额                           */
                                     /*原幣立帳稅額                           */
rme192      number(20,6),            /*原币立帐含税金额                       */
                                     /*原幣立帳含稅金額                       */
rme20       varchar2(1),             /*No Use                                 */
rme21       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
rme22       varchar2(5),             /*发票别                                 */
                                     /*發票別                                 */
rme28       varchar2(1),             /*结案码                                 */
                                     /*結案碼 Y/N                             */
rme29       varchar2(1),             /*1:内销 2:外销                          */
                                     /*1:內銷 2:外銷                          */
rme30       number(9,4),             /*利润率                                 */
                                     /*利潤率                                 */
rme31       varchar2(1),             /*报关INVOICE审核否                      */
                                     /*報關INVOICE確認否(Y/N)                 */
rme32       varchar2(1),             /*随机INVOICE审核否                      */
                                     /*隨機INVOICE確認否(Y/N)                 */
rmeconf     varchar2(1),             /*审核否                                 */
                                     /*t205確認否 (Y/N)                       */
rmegen      varchar2(1),             /*审核否                                 */
                                     /*t160確認否 (Y/N)                       */
rmepost     varchar2(1),             /*扣帐否                                 */
                                     /*扣帳否 (Y/N)                           */
rmeprin     varchar2(1),             /*打印否                                 */
                                     /*列印否 (Y/N)                           */
rmepack     varchar2(1),             /*包装否                                 */
                                     /*包裝否 (Y/N)                           */
rmevoid     varchar2(1),             /*有效否                                 */
                                     /*有效否 Y:有效 N:作廢                   */
rmeuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rmegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rmemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rmedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
rme076      varchar2(255),           /*送货地址-4                             */
rme077      varchar2(255),           /*送货地址-5                             */
rmeud01     varchar2(255),           /*自订字段-Textedit                      */
rmeud02     varchar2(40),            /*自订字段-文字                          */
rmeud03     varchar2(40),            /*自订字段-文字                          */
rmeud04     varchar2(40),            /*自订字段-文字                          */
rmeud05     varchar2(40),            /*自订字段-文字                          */
rmeud06     varchar2(40),            /*自订字段-文字                          */
rmeud07     number(15,3),            /*自订字段-数值                          */
rmeud08     number(15,3),            /*自订字段-数值                          */
rmeud09     number(15,3),            /*自订字段-数值                          */
rmeud10     number(10),              /*自订字段-整数                          */
rmeud11     number(10),              /*自订字段-整数                          */
rmeud12     number(10),              /*自订字段-整数                          */
rmeud13     date,                    /*自订字段-日期                          */
rmeud14     date,                    /*自订字段-日期                          */
rmeud15     date,                    /*自订字段-日期                          */
rmeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmelegal    varchar2(10) NOT NULL,   /*所属法人                               */
rmeoriu     varchar2(10),            /*资料建立者                             */
rmeorig     varchar2(10)             /*资料建立部门                           */
);

alter table rme_file add  constraint rme_pk primary key  (rme01) enable validate;
grant select on rme_file to tiptopgp;
grant update on rme_file to tiptopgp;
grant delete on rme_file to tiptopgp;
grant insert on rme_file to tiptopgp;
grant index on rme_file to public;
grant select on rme_file to ods;
