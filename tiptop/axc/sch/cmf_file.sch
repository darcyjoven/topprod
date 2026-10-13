/*
================================================================================
檔案代號:cmf_file
檔案名稱:LCM 料件市价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cmf_file
(
cmf01       number(5) DEFAULT '0' NOT NULL, /*年度*/
cmf02       number(5) DEFAULT '0' NOT NULL, /*月份*/
cmf03       varchar2(10) DEFAULT ' ' NOT NULL, /*分类码*/
cmf031      varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类*/
cmf04       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
cmf05       number(20,6),            /*市价                                   */
cmf06       varchar2(1) DEFAULT ' ' NOT NULL, /*料件分类来源*/
cmfdate     date,                    /*最近更改日                             */
cmfgrup     varchar2(10),            /*资料所有部门                           */
cmfmodu     varchar2(10),            /*资料更改者                             */
cmfuser     varchar2(10),            /*资料所有者                             */
cmforig     varchar2(10),            /*资料建立部门                           */
cmforiu     varchar2(10),            /*资料建立者                             */
cmflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cmf_file add  constraint cmf_pk primary key  (cmf01,cmf02,cmf03,cmf031,cmf04,cmf06) enable validate;
grant select on cmf_file to tiptopgp;
grant update on cmf_file to tiptopgp;
grant delete on cmf_file to tiptopgp;
grant insert on cmf_file to tiptopgp;
grant index on cmf_file to public;
grant select on cmf_file to ods;
