/*
================================================================================
檔案代號:apk_file
檔案名稱:发票明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apk_file
(
apk01       varchar2(20) NOT NULL,   /*帐款单号/凭证编号                      */
                                     /*帳款單號/傳票編號                      */
apk02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
apk03       varchar2(1000) NOT NULL, /*发票号码                               */
                                     /*發票號碼                               */
apk04       varchar2(20),            /*厂商税号                               */
                                     /*廠商統一編號                           */
apk05       date,                    /*发票日期                               */
                                     /*發票日期                               */
apk06       number(20,6) NOT NULL,   /*含税金额                               */
                                     /*含稅金額(本幣)                         */
apk06f      number(20,6),            /*含税金额                               */
                                     /*含稅金額(原幣)                 02/09/10*/
apk07       number(20,6) NOT NULL,   /*税额                                   */
                                     /*稅額    (本幣)                         */
apk07f      number(20,6),            /*税额                                   */
                                     /*稅額    (原幣)                 02/09/10*/
apk08       number(20,6) NOT NULL,   /*税前金额                               */
                                     /*未稅金額(本幣)                         */
apk08f      number(20,6),            /*税前金额                               */
                                     /*未稅金額(原幣)                 02/09/10*/
apk09       varchar2(1),             /*汇加注记                               */
                                     /*彙加註記                               */
apk10       varchar2(1),             /*通关注记                               */
                                     /*通關註記                               */
                                     /*1.非經海關出口應附證明文件之零稅率銷售額*/
                                     /*2.經海關出口應附證明文件之零稅率銷售額 */
                                     /*空白代表進項憑證或非銷項零稅率之資料   */
apk11       varchar2(4),             /*税种                                   */
                                     /*稅別                           02/09/10*/
apk12       varchar2(4),             /*币种                                   */
                                     /*幣別                           02/09/10*/
apk13       number(20,10),           /*汇率                                   */
                                     /*匯率   No.7952                 02/09/10*/
apk17       varchar2(1),             /*扣抵区分                               */
                                     /*扣抵區分 (1,2,3,4)                     */
apk171      varchar2(2),             /*格式                                   */
                                     /*(21,22,23,24,25,26,27,28,29,XX不申報)  */
apk172      varchar2(1),             /*课税种                                 */
                                     /*課稅別  (1.應稅 2.零稅率 3.免稅)       */
                                     /*大陸用:                                */
                                     /**進項發票種類 : A.農產品收購憑證       */
                                     /*                T.運輸發票             */
                                     /*                W.廢舊物資收購憑證     */
                                     /*                Z.其他                 */
                                     /*                S.可抵扣專用發票       */
                                     /*                N.不可抵扣專用發票     */
                                     /*                G.海關代徵完稅憑證     */
                                     /**銷項發票種類 : A.增值稅專用發票       */
                                     /*                B.普通發票             */
                                     /*                C.免用發票             */
apk173      number(5),               /*申报年度                               */
                                     /*申報年度(西元)                         */
apk174      number(5),               /*申报月份                               */
                                     /*申報月份                               */
apk175      number(10),              /*申报流水编号                           */
                                     /*申報流水編號                           */
apk22       varchar2(10),            /*申报部门                               */
                                     /*申報部門                               */
apk25       varchar2(255),           /*备注                                   */
                                     /*備註   02/07/15 char(18)-->char(40)    */
apk26       varchar2(20),            /*请款折让之对应之请款单                 */
                                     /*請款折讓之對應之請款單  98/10/22 add   */
apk27       number(5),               /*项次                                   */
                                     /*項次                    98/10/22 add   */
apk28       varchar2(20),            /*发票代码                               */
                                     /*發票代碼                for 稅控系統   */
apk29       number(9,4),             /*税率                                   */
                                     /*稅率                    for 稅控系統   */
                                     /*no.5954 增加稅別欄位，因此本欄位記錄稅率*/
apk30       number(15,3),            /*数量                                   */
                                     /*數量                    for 稅控系統   */
apkacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
apkuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
apkgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
apkmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
apkdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
apk31       varchar2(1),             /*直接扣抵类型                           */
apklegal    varchar2(10) NOT NULL,   /*所属法人                               */
apk32       varchar2(20),            /*申报税号                               */
apkorig     varchar2(10),            /*资料建立部门                           */
apkoriu     varchar2(10)             /*资料建立者                             */
);

create        index apk_02 on apk_file (apk03);
alter table apk_file add  constraint apk_pk primary key  (apk01,apk02,apk03) enable validate;
grant select on apk_file to tiptopgp;
grant update on apk_file to tiptopgp;
grant delete on apk_file to tiptopgp;
grant insert on apk_file to tiptopgp;
grant index on apk_file to public;
grant select on apk_file to ods;
