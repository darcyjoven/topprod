/*
================================================================================
檔案代號:cdj_file
檔案名稱:每月销货成本科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdj_file
(
cdj01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdj02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdj03       number(5) DEFAULT '0' NOT NULL, /*期别*/
cdj04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdj05       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
cdj06       varchar2(40) DEFAULT ' ' NOT NULL, /*料件*/
cdj07       varchar2(10),            /*理由码                                 */
cdj08       varchar2(24),            /*主营业务成本科目                       */
cdj09       varchar2(24),            /*库存商品科目                           */
cdj10       number(15,3) DEFAULT '0' NOT NULL, /*销货数量*/
cdj11       number(20,6) DEFAULT '0' NOT NULL, /*銷貨單價*/
cdj12       number(20,6) DEFAULT '0' NOT NULL, /*销货金额*/
cdj13       varchar2(30),            /*分录底稿单号                           */
cdjconf     varchar2(1) NOT NULL,    /*审核否                                 */
cdjlegal    varchar2(10),            /*所属法人                               */
cdj14       varchar2(10),            /*客户                                   */
cdj15       varchar2(24),            /*部门                                   */
cdj16       varchar2(10),            /*no use                                 */
cdj142      varchar2(40),            /*客户简称                               */
cdj17       number(5) DEFAULT '0' NOT NULL, /*项次*/
cdj00       varchar2(1) DEFAULT ' ' NOT NULL /*类型*/
);

alter table cdj_file add  constraint cdj_pk primary key  (cdj00,cdj01,cdj02,cdj03,cdj04,cdj17) enable validate;
grant select on cdj_file to tiptopgp;
grant update on cdj_file to tiptopgp;
grant delete on cdj_file to tiptopgp;
grant insert on cdj_file to tiptopgp;
grant index on cdj_file to public;
grant select on cdj_file to ods;
