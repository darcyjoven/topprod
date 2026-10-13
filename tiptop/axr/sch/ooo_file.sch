/*
================================================================================
檔案代號:ooo_file
檔案名稱:应收账款系统科目余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ooo_file
(
ooo01       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
ooo02       varchar2(40) NOT NULL,   /*客户简称                               */
                                     /*客戶簡稱                               */
ooo03       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
ooo04       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
ooo05       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
ooo06       number(5) NOT NULL,      /*年度                                   */
ooo07       number(5) NOT NULL,      /*期别                                   */
                                     /*期別 (0:年初餘額 1/2/3..:各期餘額)     */
ooo08d      number(20,6) NOT NULL,   /*原币借方金额                           */
                                     /*原幣借方金額                           */
ooo08c      number(20,6) NOT NULL,   /*原币贷方金额                           */
                                     /*原幣貸方金額                           */
ooo09d      number(20,6) NOT NULL,   /*本币借方金额                           */
                                     /*本幣借方金額                           */
ooo09c      number(20,6) NOT NULL,   /*本币贷方金额                           */
                                     /*本幣貸方金額                           */
ooo10       varchar2(10) NOT NULL,   /*总账营运中心                           */
                                     /*营运中心编号                           */
ooo11       varchar2(5) NOT NULL,    /*帐套                                   */
                                     /*帳別                                   */
ooo12       varchar2(1) DEFAULT ' ' NOT NULL, /*资料来源*/
                                     /*資料來源 0:開帳 1:表月結               */
ooolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ooo_file add  constraint ooo_pk primary key  (ooo10,ooo11,ooo01,ooo02,ooo03,ooo04,ooo05,ooo06,ooo07,ooo12) enable validate;
grant select on ooo_file to tiptopgp;
grant update on ooo_file to tiptopgp;
grant delete on ooo_file to tiptopgp;
grant insert on ooo_file to tiptopgp;
grant index on ooo_file to public;
grant select on ooo_file to ods;
