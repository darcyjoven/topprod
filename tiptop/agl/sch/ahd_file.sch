/*
================================================================================
檔案代號:ahd_file
檔案名稱:常用及分摊凭证比率科目资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ahd_file
(
ahd00       varchar2(5) NOT NULL,    /*帐套                                   */
ahd000      varchar2(1) NOT NULL,    /*性质(1)固定金额常用凭证                */
ahd01       varchar2(8) NOT NULL,    /*原始编号                               */
ahd02       number(5) NOT NULL,      /*项次                                   */
ahd03       varchar2(24),            /*分摊金额来源科目                       */
ahd04       varchar2(10)             /*分摊金额来源部门                       */
);

alter table ahd_file add  constraint ahd_pk primary key  (ahd01,ahd02,ahd00,ahd000) enable validate;
grant select on ahd_file to tiptopgp;
grant update on ahd_file to tiptopgp;
grant delete on ahd_file to tiptopgp;
grant insert on ahd_file to tiptopgp;
grant index on ahd_file to public;
grant select on ahd_file to ods;
