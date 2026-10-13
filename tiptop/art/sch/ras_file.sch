/*
================================================================================
檔案代號:ras_file
檔案名稱:换赠第二单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ras_file
(
ras01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
ras02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
ras03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销类型 2:组合促销 3:满额促 */
ras04       number(5) DEFAULT '0' NOT NULL, /*项次*/
ras05       number(5) DEFAULT '0' NOT NULL, /*组别*/
ras06       varchar2(2) DEFAULT ' ' NOT NULL, /*数据类型01.产品、02.产品分类 */
ras07       varchar2(40),            /*代码                                   */
ras08       varchar2(4),             /*单位                                   */
rasacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
raslegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rasplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
ras09       number(20,6) DEFAULT '0' NOT NULL /*送抵现值金额*/
);

alter table ras_file add  constraint ras_pk primary key  (ras01,ras02,ras03,ras04,ras05,ras06,rasplant) enable validate;
grant select on ras_file to tiptopgp;
grant update on ras_file to tiptopgp;
grant delete on ras_file to tiptopgp;
grant insert on ras_file to tiptopgp;
grant index on ras_file to public;
grant select on ras_file to ods;
