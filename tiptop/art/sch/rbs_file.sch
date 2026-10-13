/*
================================================================================
檔案代號:rbs_file
檔案名稱:换赠变更资料单身档(二)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbs_file
(
rbs01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbs02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbs03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbs04       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
rbs05       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbs06       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
rbs07       number(5) DEFAULT '0' NOT NULL, /*项次*/
rbs08       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbs09       varchar2(2) DEFAULT ' ' NOT NULL, /*資料類型01.產品、02.產品分類 */
rbs10       varchar2(40),            /*编号                                   */
rbs11       varchar2(4),             /*单位                                   */
rbsacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
rbslegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbsplant    varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
rbs12       number(20,6) DEFAULT '0' NOT NULL /*送抵现值金额*/
);

alter table rbs_file add  constraint rbs_pk primary key  (rbs01,rbs02,rbs03,rbs04,rbs05,rbs06,rbs07,rbs08,rbs09,rbsplant) enable validate;
grant select on rbs_file to tiptopgp;
grant update on rbs_file to tiptopgp;
grant delete on rbs_file to tiptopgp;
grant insert on rbs_file to tiptopgp;
grant index on rbs_file to public;
grant select on rbs_file to ods;
