/*
================================================================================
檔案代號:raq_file
檔案名稱:生效机构资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table raq_file
(
raq01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
raq02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销编号*/
raq03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
raq04       varchar2(10) DEFAULT ' ' NOT NULL, /*生效营运中心编号*/
raq05       varchar2(1) DEFAULT ' ' NOT NULL, /*发布否*/
raqacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
raqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
raqplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
raq06       date,                    /*发布日期                               */
raq07       varchar2(8),             /*發佈時間                               */
raq08       varchar2(20) DEFAULT ' ' NOT NULL /*摊位编号*/
);

alter table raq_file add  constraint raq_pk primary key  (raq01,raq02,raq03,raq04,raq08,raqplant) enable validate;
grant select on raq_file to tiptopgp;
grant update on raq_file to tiptopgp;
grant delete on raq_file to tiptopgp;
grant insert on raq_file to tiptopgp;
grant index on raq_file to public;
grant select on raq_file to ods;
