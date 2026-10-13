/*
================================================================================
檔案代號:fae_file
檔案名稱:多部门折旧费用分摊单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fae_file
(
fae01       number(5) NOT NULL,      /*资料年度                               */
fae02       number(5) NOT NULL,      /*资料月份                               */
fae03       varchar2(24) NOT NULL,   /*折旧会计科目                           */
fae04       varchar2(10) NOT NULL,   /*分摊类型                               */
fae05       number(5) NOT NULL,      /*项次                                   */
fae06       varchar2(10),            /*分摊部门                               */
fae07       varchar2(24),            /*折旧科目                               */
fae08       number(9,4),             /*分摊比率                               */
fae09       varchar2(24),            /*变动比率分子科目                       */
fae071      varchar2(24),            /*折旧科目二                             */
fae10       varchar2(1) DEFAULT '1' NOT NULL /*类型*/
);

alter table fae_file add  constraint fae_pk primary key  (fae10,fae01,fae02,fae03,fae04,fae05) enable validate;
grant select on fae_file to tiptopgp;
grant update on fae_file to tiptopgp;
grant delete on fae_file to tiptopgp;
grant insert on fae_file to tiptopgp;
grant index on fae_file to public;
grant select on fae_file to ods;
