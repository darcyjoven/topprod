/*
================================================================================
檔案代號:git_file
檔案名稱:人工录入金额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table git_file
(
git01       varchar2(6) NOT NULL,    /*群组代码                               */
                                     /*群組代碼                               */
git02       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
git03       varchar2(20) NOT NULL,   /*编号                                   */
                                     /*編號                                   */
git06       number(5) NOT NULL,      /*年度                                   */
git07       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
git04       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
git05       number(20,6),            /*人工录入金额                           */
                                     /*人工輸入金額                           */
git00       varchar2(5) NOT NULL,    /*帐套                                   */
git08       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
git09       varchar2(10) DEFAULT ' ' NOT NULL /*母公司编号*/
);

alter table git_file add  constraint git_pk primary key  (git00,git01,git02,git03,git06,git07,git08,git09) enable validate;
grant select on git_file to tiptopgp;
grant update on git_file to tiptopgp;
grant delete on git_file to tiptopgp;
grant insert on git_file to tiptopgp;
grant index on git_file to public;
grant select on git_file to ods;
