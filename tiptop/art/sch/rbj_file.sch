/*
================================================================================
檔案代號:rbj_file
檔案名稱:满额促销变更第二单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbj_file
(
rbj01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbj02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbj03       number(5) DEFAULT '0' NOT NULL, /*异动序号*/
rbj04       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbj05       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
rbj06       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbj07       varchar2(2) DEFAULT ' ' NOT NULL, /*数据类型01.产品、02.产品分类 */
rbj08       varchar2(40),            /*代码                                   */
rbj09       varchar2(4),             /*单位                                   */
rbjacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
rbjlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbjplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rbj_file add  constraint rbj_pk primary key  (rbj01,rbj02,rbj03,rbj04,rbj05,rbj06,rbj07,rbjplant) enable validate;
grant select on rbj_file to tiptopgp;
grant update on rbj_file to tiptopgp;
grant delete on rbj_file to tiptopgp;
grant insert on rbj_file to tiptopgp;
grant index on rbj_file to public;
grant select on rbj_file to ods;
