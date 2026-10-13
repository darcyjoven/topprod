/*
================================================================================
檔案代號:srm_file
檔案名稱:产品投入工时单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table srm_file
(
srm01       number(5) NOT NULL,      /*年度                                   */
srm02       number(5) NOT NULL,      /*月份                                   */
srm03       varchar2(40) NOT NULL,   /*产品编号                               */
srm04       number(15,3),            /*在制数量                               */
srm05       number(15,3),            /*人工完成%                              */
srm06       number(15,3)             /*制费完成%                              */
);

alter table srm_file add  constraint srm_pk primary key  (srm01,srm02,srm03) enable validate;
grant select on srm_file to tiptopgp;
grant update on srm_file to tiptopgp;
grant delete on srm_file to tiptopgp;
grant insert on srm_file to tiptopgp;
grant index on srm_file to public;
grant select on srm_file to ods;
