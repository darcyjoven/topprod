/*
================================================================================
檔案代號:apn_file
檔案名稱:AAP-账款统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table apn_file
(
apn00       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
apn01       varchar2(10) NOT NULL,   /*付款厂商                               */
                                     /*付款廠商                               */
apn02       varchar2(40) DEFAULT ' ' NOT NULL, /*厂商简称*/
                                     /*廠商簡稱(一般應付帳款)                 */
                                     /*預購單號(預付購料款)                   */
apn03       varchar2(10),            /*部门                                   */
                                     /*部門                                   */
apn04       number(5) NOT NULL,      /*年度                                   */
apn05       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
                                     /*系統年結時會產生一筆 '0' 期資料        */
                                     /*程式的期初皆以sum(借-貸)               */
apn06       number(20,6),            /*借方金额                               */
                                     /*借方金額                               */
apn07       number(20,6),            /*贷方金额                               */
                                     /*貸方金額                               */
apn08       varchar2(10) NOT NULL,   /*总账营运中心                           */
                                     /*营运中心编号                           */
apn09       varchar2(5) NOT NULL,    /*帐套                                   */
                                     /*帳別                                   */
apn10       varchar2(20) NOT NULL,   /*立冲编号                               */
                                     /*立沖編號                               */
                                     /*2002.1.4 將以下Report所列欄位直接記錄  */
apn11       date,                    /*帐款日                                 */
                                     /*帳款日                                 */
apn12       varchar2(20),            /*抛转凭证编号                           */
                                     /*拋轉傳票編號 npp01(npq01)              */
apn13       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
apn14       varchar2(4),             /*币种                                   */
                                     /*幣別          azi01                    */
apn15       number(20,10),           /*汇率                                   */
                                     /*匯率    No.7952                        */
apn16       varchar2(40) DEFAULT ' ',/*付款厂商简称                           */
                                     /*付款廠商簡稱                           */
apn17       varchar2(30),            /*No Use                                 */
apn18       varchar2(30),            /*No Use                                 */
apnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index apn_02 on apn_file (apn01,apn02);
alter table apn_file add  constraint apn_pk primary key  (apn08,apn09,apn00,apn01,apn02,apn04,apn05,apn10) enable validate;
grant select on apn_file to tiptopgp;
grant update on apn_file to tiptopgp;
grant delete on apn_file to tiptopgp;
grant insert on apn_file to tiptopgp;
grant index on apn_file to public;
grant select on apn_file to ods;
