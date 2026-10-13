/*
================================================================================
檔案代號:aeg_file
檔案名稱:项目分类账档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aeg_file
(
aeg00       varchar2(5),             /*帐套                                   */
aeg01       varchar2(24),            /*科目编号                               */
aeg02       date,                    /*凭证日期                               */
aeg03       varchar2(20),            /*凭证编号                               */
aeg04       number(5),               /*项次                                   */
aeg05       varchar2(10),            /*项目编号                               */
aeglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index aeg_01 on aeg_file (aeg01,aeg05,aeg02);
create        index aeg_03 on aeg_file (aeg03,aeg04);
create        index aeg_02 on aeg_file (aeg05,aeg01,aeg02);
grant select on aeg_file to tiptopgp;
grant update on aeg_file to tiptopgp;
grant delete on aeg_file to tiptopgp;
grant insert on aeg_file to tiptopgp;
grant index on aeg_file to public;
grant select on aeg_file to ods;
