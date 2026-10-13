/*
================================================================================
檔案代號:rad_file
檔案名稱:一般促销资料第二单身表
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rad_file
(
rad01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rad02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rad03       number(5) DEFAULT '0' NOT NULL, /*组别*/
rad04       varchar2(2) DEFAULT ' ' NOT NULL, /*数据类型01.产品、02.产品分类 */
rad05       varchar2(40) DEFAULT ' ' NOT NULL, /*代码*/
rad06       varchar2(4),             /*单位                                   */
radacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
radlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
radplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rad_file add  constraint rad_pk primary key  (rad01,rad02,rad03,rad04,rad05,radplant) enable validate;
grant select on rad_file to tiptopgp;
grant update on rad_file to tiptopgp;
grant delete on rad_file to tiptopgp;
grant insert on rad_file to tiptopgp;
grant index on rad_file to public;
grant select on rad_file to ods;
