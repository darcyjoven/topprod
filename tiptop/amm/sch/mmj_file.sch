/*
================================================================================
檔案代號:mmj_file
檔案名稱:加工通知单单头底稿
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mmj_file
(
mmj01       varchar2(20) NOT NULL,   /*加工通知单号                           */
                                     /*加工通知單號                           */
mmj02       date,                    /*加工通知单下单日期                     */
                                     /*加工通知單下單日期                     */
mmj03       varchar2(10),            /*供应厂商                               */
                                     /*供應廠商 pmc01                         */
                                     /*下單供應廠商                           */
                                     /*輸入供應商編號交易狀況為               */
                                     /*0: 已核淮(可接受)                      */
                                     /*1: 尚待核淮(提示警告訊息確認後可接受)  */
                                     /*2: 不淮交易(不可接受)                  */
mmj04       varchar2(10),            /*送货地址                               */
                                     /*送貨地址 pme01,pme02<>'1'              */
                                     /*輸入此批加工需求的送貨地址             */
mmj05       varchar2(10),            /*帐单地址                               */
                                     /*帳單地址 pme01,pme02<>'0'              */
                                     /*輸入此批加工需求的帳單地址             */
mmj06       varchar2(10),            /*加工需求员                             */
                                     /*加工需求員 gen01                       */
                                     /*輸入批加工需求的加工需求員代號, 可空白 */
                                     /*如果有設定加工需求員, 則需存在 員工檔  */
mmj07       varchar2(10),            /*加工需求部门                           */
                                     /*加工需求部門 gem01                     */
mmj08       varchar2(8),             /*No Use                                 */
mmj09       varchar2(1),             /*No Use                                 */
mmj10       varchar2(10),            /*付款方式                               */
                                     /*付款方式 pma01                         */
                                     /*輸入此批加工需求的付款方式             */
mmj11       varchar2(4),             /*税种                                   */
                                     /*稅別 gec01                             */
                                     /*輸入此批加工需求的稅別, 不可空白       */
mmj12       varchar2(4),             /*币种                                   */
                                     /*幣別 azi01                             */
                                     /*輸入此批加工需求的幣別, 不可空白       */
mmj13       number(20,6),            /*总金额                                 */
                                     /*總金額                                 */
                                     /*系統維護                               */
                                     /*加工需求單身各項資料的  單價 * 數量 之總*/
mmj14       varchar2(6),             /*价格条件                               */
                                     /*價格條件 oah01                (97/06/19)*/
mmj15       number(5),               /*总工时                                 */
                                     /*總工時                                 */
mmjprno     number(5),               /*已打印次数                             */
                                     /*Printed Times                          */
                                     /*Printed Times Of The Process Demand Doc.Can Ctrol Reinssue The Process Demand Doc. Because Of Reprinting*/
mmjprdt     date,                    /*最后打印日期                           */
                                     /*Last Print Date                        */
                                     /*Last Print Date Of The Process Demand Doc. Help To Control Print And Inssue*/
mmjacti     varchar2(1),             /*资料有效码                             */
mmjuser     varchar2(10),            /*资料所有者                             */
mmjgrup     varchar2(10),            /*资料所有部门                           */
mmjmodu     varchar2(10),            /*资料更改者                             */
mmjdate     date,                    /*最近更改日                             */
mmjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
mmjorig     varchar2(10),            /*资料建立部门                           */
mmjoriu     varchar2(10)             /*资料建立者                             */
);

alter table mmj_file add  constraint mmj_pk primary key  (mmj01) enable validate;
grant select on mmj_file to tiptopgp;
grant update on mmj_file to tiptopgp;
grant delete on mmj_file to tiptopgp;
grant insert on mmj_file to tiptopgp;
grant index on mmj_file to public;
grant select on mmj_file to ods;
