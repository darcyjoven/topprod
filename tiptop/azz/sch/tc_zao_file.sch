/*
================================================================================
檔案代號:tc_zao_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zao_file
(
zao01       varchar2(80) NOT NULL,   /*查询单id                               */
zao02       varchar2(1) NOT NULL,    /*layout 项目                            */
zao03       varchar2(1) NOT NULL,    /*录入格式                               */
zao04       varchar2(1),             /*运行否                                 */
zao05       varchar2(1) NOT NULL     /*客制码                                 */
);

grant select on tc_zao_file to tiptopgp;
grant update on tc_zao_file to tiptopgp;
grant delete on tc_zao_file to tiptopgp;
grant insert on tc_zao_file to tiptopgp;
grant index on tc_zao_file to public;
grant select on tc_zao_file to ods;
