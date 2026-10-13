/*
================================================================================
檔案代號:pmd_file
檔案名稱:供应厂商联络资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmd_file
(
pmd01       varchar2(10) NOT NULL,   /*供应厂商编号                           */
                                     /*供應廠商編號                           */
pmd02       varchar2(30) NOT NULL,   /*联络人                                 */
                                     /*聯絡人                                 */
pmd03       varchar2(40),            /*联络电话                               */
                                     /*聯絡電話                               */
pmd04       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
pmd05       varchar2(1),             /*是否为主要联络人                       */
                                     /*是否為主要聯絡人                       */
                                     /*若是, 則本聯絡人將列印於採購跟催表上   */
                                     /*一個供應廠商僅可有一個主要聯絡人       */
pmd06       varchar2(4) NOT NULL,    /*类型                                   */
                                     /*類別                                   */
                                     /*此類別於列印供應廠商名條時可為挑選的條件*/
pmd07       varchar2(80),            /*E-Mail address                         */
pmd08       varchar2(1) DEFAULT 'N' NOT NULL /*是否寄Mail*/
);

alter table pmd_file add  constraint pmd_pk primary key  (pmd01,pmd02,pmd06) enable validate;
grant select on pmd_file to tiptopgp;
grant update on pmd_file to tiptopgp;
grant delete on pmd_file to tiptopgp;
grant insert on pmd_file to tiptopgp;
grant index on pmd_file to public;
grant select on pmd_file to ods;
