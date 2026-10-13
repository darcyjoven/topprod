/*
================================================================================
檔案代號:lqw_file
檔案名稱:销售折价明细档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqw_file
(
lqw00       varchar2(2) DEFAULT ' ' NOT NULL, /*单据别:01.订单 02.销售单 03.销 */
lqw01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
lqw02       varchar2(2) DEFAULT ' ' NOT NULL, /*折价方式:02.组合促销 03.满额  */
lqw03       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
lqw04       number(5) DEFAULT '0' NOT NULL, /*促销组别*/
lqw05       number(5) DEFAULT '0' NOT NULL, /*促销换赠项次*/
lqw06       number(5) DEFAULT '0' NOT NULL, /*no use*/
lqw07       number(5) DEFAULT '0' NOT NULL, /*项次*/
lqw08       varchar2(20) DEFAULT ' ' NOT NULL, /*券种编号*/
lqw09       varchar2(20),            /*券起始编号                             */
lqw10       varchar2(20),            /*券截止编号                             */
lqw11       varchar2(10),            /*券面额编号                             */
lqw12       number(20),              /*券张数                                 */
lqw13       number(20,2),            /*总金额                                 */
lqwlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lqwplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lqw_file add  constraint lqw_pk primary key  (lqw00,lqw01,lqw02,lqw04,lqw05,lqw06,lqw07) enable validate;
grant select on lqw_file to tiptopgp;
grant update on lqw_file to tiptopgp;
grant delete on lqw_file to tiptopgp;
grant insert on lqw_file to tiptopgp;
grant index on lqw_file to public;
grant select on lqw_file to ods;
