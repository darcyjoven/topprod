/*
================================================================================
檔案代號:apm_file
檔案名稱:AAP-账款统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table apm_file
(
apm00       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
apm01       varchar2(10) NOT NULL,   /*付款厂商                               */
                                     /*付款廠商                               */
apm02       varchar2(40) NOT NULL,   /*厂商简称                               */
                                     /*廠商簡稱(一般應付帳款)                 */
                                     /*預購單號(預付購料款)                   */
apm03       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
apm04       number(5) NOT NULL,      /*年度                                   */
apm05       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
                                     /*系統年結時會產生一筆 '0' 期資料        */
                                     /*程式的期初皆以sum(借-貸)               */
apm06f      number(20,6),            /*原币借方金额                           */
                                     /*原幣借方金額                    NO.A074*/
apm06       number(20,6),            /*本币借方金额                           */
                                     /*本幣借方金額                    NO.A074*/
apm07f      number(20,6),            /*原币贷方金额                           */
                                     /*原幣貸方金額                    NO.A074*/
apm07       number(20,6),            /*本币贷方金额                           */
                                     /*本幣貸方金額                    NO.A074*/
apm08       varchar2(10) NOT NULL,   /*总账营运中心                           */
                                     /*营运中心编号                           */
apm09       varchar2(5) NOT NULL,    /*帐套                                   */
                                     /*帳別                                   */
apm10       varchar2(1) NOT NULL,    /*来源                                   */
                                     /*來源 0:表開帳 1:表月結產生 #No.B372 0104*/
apm11       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                            NO.A074*/
apmlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index apm_02 on apm_file (apm01,apm02);
alter table apm_file add  constraint apm_pk primary key  (apm08,apm09,apm00,apm10,apm01,apm02,apm03,apm11,apm04,apm05) enable validate;
grant select on apm_file to tiptopgp;
grant update on apm_file to tiptopgp;
grant delete on apm_file to tiptopgp;
grant insert on apm_file to tiptopgp;
grant index on apm_file to public;
grant select on apm_file to ods;
