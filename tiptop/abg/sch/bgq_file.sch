/*
================================================================================
檔案代號:bgq_file
檔案名稱:部门科目预算作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgq_file
(
bgq01       varchar2(10) NOT NULL,   /*版本                                   */
bgq02       number(5) NOT NULL,      /*年度                                   */
bgq03       number(5) NOT NULL,      /*月份                                   */
bgq04       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
bgq05       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
bgq06       number(20,6),            /*预算异动                               */
                                     /*預算異動                               */
bgq061      number(20,6),            /*预算异动分摊                           */
                                     /*預算異動分攤                           */
bgq07       number(20,6),            /*累积预算金额                           */
                                     /*累積預算金額                           */
bgq08       number(20,6),            /*追加预算                               */
                                     /*追加預算                               */
bgq09       varchar2(15),            /*细部分类供非用人费用使用               */
                                     /*細部分類供非用人費用使用 2003/10/15    */
                                     /*No.8563 nouse 因為尚無相關修改         */
bgq051      varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
bgq052      varchar2(30) DEFAULT ' ' NOT NULL, /*WBS编码*/
bgq053      varchar2(10) DEFAULT ' ' NOT NULL /*预算项目*/
);

alter table bgq_file add  constraint bgq_pk primary key  (bgq01,bgq02,bgq03,bgq04,bgq05,bgq051,bgq052,bgq053) enable validate;
grant select on bgq_file to tiptopgp;
grant update on bgq_file to tiptopgp;
grant delete on bgq_file to tiptopgp;
grant insert on bgq_file to tiptopgp;
grant index on bgq_file to public;
grant select on bgq_file to ods;
