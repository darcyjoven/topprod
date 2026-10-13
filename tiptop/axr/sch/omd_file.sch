/*
================================================================================
檔案代號:omd_file
檔案名稱:发票打印品名档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table omd_file
(
omd00       varchar2(2),             /*帐款类型                               */
                                     /*帳款類別 (1*:應收帳款  2*:待抵帳款)    */
omd01       varchar2(20) NOT NULL,   /*应收单号/待抵单号                      */
                                     /*應收單號/待抵單號                      */
omd03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
omd05       varchar2(4),             /*销售单位                               */
                                     /*銷售單位                               */
omd06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
omd12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
omd15       number(20,6) NOT NULL,   /*本币单价                               */
                                     /*本幣單價                               */
omd16       number(20,6) NOT NULL,   /*本币税前金额                           */
                                     /*本幣未稅金額                           */
omd16t      number(20,6) NOT NULL,   /*本币含税金额                           */
                                     /*本幣含稅金額                           */
omdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table omd_file add  constraint omd_pk primary key  (omd01,omd03) enable validate;
grant select on omd_file to tiptopgp;
grant update on omd_file to tiptopgp;
grant delete on omd_file to tiptopgp;
grant insert on omd_file to tiptopgp;
grant index on omd_file to public;
grant select on omd_file to ods;
