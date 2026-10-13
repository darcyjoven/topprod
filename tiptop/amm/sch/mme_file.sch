/*
================================================================================
檔案代號:mme_file
檔案名稱:加工通知单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mme_file
(
mme01       varchar2(20) NOT NULL,   /*加工通知单号                           */
mme02       date,                    /*加工知单下单日期                       */
mme03       varchar2(10),            /*供应厂商                               */
                                     /*供應廠商 pmc01                         */
                                     /*下單供應廠商                           */
                                     /*輸入供應商編號交易狀況為               */
                                     /*0: 已核淮(可接受)                      */
                                     /*1: 尚待核淮(提示警告訊息確認後可接受)  */
                                     /*2: 不淮交易(不可接受)                  */
mme04       varchar2(10),            /*送货地址                               */
                                     /*送貨地址 pme01,pme02<>'1'              */
                                     /*輸入此批加工需求的送貨地址             */
mme05       varchar2(10),            /*帐单地址                               */
                                     /*帳單地址 pme01,pme02<>'0'              */
                                     /*輸入此批加工需求的帳單地址             */
mme06       varchar2(10),            /*加工需求员                             */
                                     /*輸入批加工需求的加工需求員代號, 可空白 */
                                     /*如果有設定加工需求員, 則需存在員工檔   */
mme07       varchar2(10),            /*加工需求部门                           */
mme08       varchar2(8),             /*No Use                                 */
mme09       varchar2(1),             /*No Use                                 */
mme10       varchar2(10),            /*付款方式                               */
                                     /*付款方式 pma01                         */
                                     /*輸入此批加工需求的付款方式             */
mme11       varchar2(4),             /*税种                                   */
                                     /*稅別 gec01                             */
                                     /*輸入此批加工需求的稅別, 不可空白       */
mme12       varchar2(4),             /*币种                                   */
                                     /*幣別 azi01                             */
                                     /*輸入此批加工需求的幣別, 不可空白       */
mme13       number(20,6),            /*总金额                                 */
                                     /*系統維護                               */
                                     /*加工需求單身各項資料的  單價 * 數量 之總*/
mme14       varchar2(6),             /*价格条件                               */
                                     /*價格條件 oah01                (97/06/19)*/
mme15       number(5),               /*总工时                                 */
mmeprno     number(5),               /*已打印次数                             */
                                     /*此張加工需求單已列印過的次數，可控制加工*/
                                     /*否有重複列印而導致加工需求單重複的發出 */
mmeprdt     date,                    /*最后打印日期                           */
                                     /*此張加工需求單據最後列印的日期，有助於加*/
                                     /*據列印與發出之間的控制                 */
mmeacti     varchar2(1),             /*资料有效码                             */
mmeuser     varchar2(10),            /*资料所有者                             */
mmegrup     varchar2(10),            /*资料所有部门                           */
mmemodu     varchar2(10),            /*资料更改者                             */
mmedate     date,                    /*最近更改日                             */
mmeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmelegal    varchar2(10) NOT NULL,   /*所属法人                               */
mmeorig     varchar2(10),            /*资料建立部门                           */
mmeoriu     varchar2(10)             /*资料建立者                             */
);

alter table mme_file add  constraint mme_pk primary key  (mme01) enable validate;
grant select on mme_file to tiptopgp;
grant update on mme_file to tiptopgp;
grant delete on mme_file to tiptopgp;
grant insert on mme_file to tiptopgp;
grant index on mme_file to public;
grant select on mme_file to ods;
