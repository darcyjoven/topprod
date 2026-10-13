/*
================================================================================
檔案代號:vnb_file
檔案名稱:aps 單據追溯維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vnb_file
(
vnb01       varchar2(60) DEFAULT ' ' NOT NULL, /*供给来源单据编号*/
vnb02       number(15,3),            /*需求来源需求数量                       */
vnb03       varchar2(60) DEFAULT ' ' NOT NULL, /*需求来源单据编号*/
vnb04       number(1),               /*是否为需求订单                         */
vnb05       number(15,3),            /*预计供给数量                           */
vnb06       number(1),               /*采购单 or 工单                         */
vnb07       number(15,3),            /*供给最大量                             */
vnb08       number(1),               /*是否锁定                               */
vnb09       varchar2(40),            /*料号                                   */
vnblegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vnbplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vnb_file add  constraint vnb_pk primary key  (vnb01,vnb03) enable validate;
grant select on vnb_file to tiptopgp;
grant update on vnb_file to tiptopgp;
grant delete on vnb_file to tiptopgp;
grant insert on vnb_file to tiptopgp;
grant index on vnb_file to public;
grant select on vnb_file to ods;
