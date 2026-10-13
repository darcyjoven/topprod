/*
================================================================================
檔案代號:rbc_file
檔案名稱:一般促销变更第一单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbc_file
(
rbc01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbc02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbc03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbc04       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbc05       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型:0初始,1修改*/
rbc06       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbc07       varchar2(1) DEFAULT ' ' NOT NULL, /*促销方式:1:特价,2:折扣,3:折价*/
rbc08       number(20,6) DEFAULT '0' NOT NULL, /*特卖价*/
rbc09       number(5,2),             /*折扣率%                                */
rbc10       number(20,6) DEFAULT '0' NOT NULL, /*折让价*/
rbc11       varchar2(1) DEFAULT ' ' NOT NULL, /*会员促销方式*/
rbc12       number(20,6) DEFAULT '0' NOT NULL, /*会员特卖价*/
rbc13       number(5,2),             /*会员折扣率                             */
rbc14       number(20,6) DEFAULT '0' NOT NULL, /*会员折让价*/
rbc15       date,                    /*No Use                                 */
rbc16       date,                    /*No Use                                 */
rbc17       varchar2(8),             /*No Use                                 */
rbc18       varchar2(8),             /*No Use                                 */
rbc19       varchar2(1),             /*过期否                                 */
rbc20       varchar2(1),             /*限定否                                 */
rbcacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rbclegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbcplant    varchar2(10) DEFAULT ' ' NOT NULL /*营运中心编号*/
);

alter table rbc_file add  constraint rbc_pk primary key  (rbc01,rbc02,rbc03,rbc04,rbc05,rbc06,rbcplant) enable validate;
grant select on rbc_file to tiptopgp;
grant update on rbc_file to tiptopgp;
grant delete on rbc_file to tiptopgp;
grant insert on rbc_file to tiptopgp;
grant index on rbc_file to public;
grant select on rbc_file to ods;
