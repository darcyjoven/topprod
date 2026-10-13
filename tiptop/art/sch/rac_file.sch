/*
================================================================================
檔案代號:rac_file
檔案名稱:一般促销资料第一单身表
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rac_file
(
rac01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rac02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rac03       number(5) DEFAULT '0' NOT NULL, /*组别*/
rac04       varchar2(1) DEFAULT ' ' NOT NULL, /*促销方式 1:特价 2:折扣 3:折价*/
rac05       number(20,6) DEFAULT '0' NOT NULL, /*特卖价*/
rac06       number(5,2),             /*折扣率%                                */
rac07       number(20,6) DEFAULT '0' NOT NULL, /*折让金额*/
rac08       varchar2(1) DEFAULT ' ' NOT NULL, /*会员促销方式*/
rac09       number(20,6) DEFAULT '0' NOT NULL, /*会员特卖价*/
rac10       number(5,2),             /*会员折扣率%                            */
rac11       number(20,6) DEFAULT '0' NOT NULL, /*会员折让额*/
rac12       date,                    /*No Use                                 */
rac13       date,                    /*No Use                                 */
rac14       varchar2(8),             /*No Use                                 */
rac15       varchar2(8),             /*No Use                                 */
rac16       varchar2(1) DEFAULT ' ' NOT NULL, /*周期否，预留目前不使用*/
rac17       varchar2(1) DEFAULT ' ' NOT NULL, /*限定否，预留目前不使用*/
racacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
raclegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
racplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
racpos      varchar2(1) DEFAULT '1' NOT NULL /*已传POS否*/
);

alter table rac_file add  constraint rac_pk primary key  (rac01,rac02,rac03,racplant) enable validate;
grant select on rac_file to tiptopgp;
grant update on rac_file to tiptopgp;
grant delete on rac_file to tiptopgp;
grant insert on rac_file to tiptopgp;
grant index on rac_file to public;
grant select on rac_file to ods;
