/*
================================================================================
檔案代號:azd_file
檔案名稱:签核过程档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azd_file
(
azd01       varchar2(20) NOT NULL,   /*单据编号                               */
                                     /*單據編號                               */
azd02       number(5) NOT NULL,      /*单据类型                               */
                                     /*單據類別 (與 aze09 同)                 */
                                     /*1.報價單 2.請購單 3.採購單 4.傳票      */
                                     /*5.銷貨單 6.傳票底稿                    */
                                     /*7.常用傳票(固定金額)8.常用傳票(固定比率)*/
                                     /*9.調撥 10.設計變更單 11.應付帳款       */
                                     /*12.付款單   13.銷單(內銷)出貨單        */
                                     /*14.銷單(外銷)出貨單 15.銷貨折讓單      */
                                     /*16.銷退單  17.預收貨款單 18.複運出口出貨*/
                                     /*19.收款沖帳 20.開狀單 21.贖單          */
                                     /*22:借項單 23:貸項單  24:呆帳單         */
                                     /*25.訂單   26.訂單變更                  */
azd03       varchar2(10) NOT NULL,   /*签核人员编号                           */
                                     /*簽核人員代號                           */
azd04       date                     /*签核日期                               */
                                     /*簽核日期                               */
);

alter table azd_file add  constraint azd_pk primary key  (azd01,azd02,azd03) enable validate;
grant select on azd_file to tiptopgp;
grant update on azd_file to tiptopgp;
grant delete on azd_file to tiptopgp;
grant insert on azd_file to tiptopgp;
grant index on azd_file to public;
grant select on azd_file to ods;
