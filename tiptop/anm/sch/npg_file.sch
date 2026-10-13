/*
================================================================================
檔案代號:npg_file
檔案名稱:银行存款期初开账档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table npg_file
(
npg01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行編號                               */
npg02       number(5) NOT NULL,      /*年度                                   */
npg03       number(5) NOT NULL,      /*月份                                   */
npg06       number(20,6) NOT NULL,   /*出纳月底结存                           */
                                     /*出納月底結存(原幣)                     */
npg09       number(20,6) NOT NULL,   /*出纳月底结存                           */
                                     /*出納月底結存(本幣)                     */
npg16       number(20,6) NOT NULL,   /*总帐月底结存                           */
                                     /*總帳月底結存(原幣)                     */
npg19       number(20,6) NOT NULL,   /*总帐月底结存                           */
                                     /*總帳月底結存(本幣)                     */
npglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table npg_file add  constraint npg_pk primary key  (npg01,npg02,npg03) enable validate;
grant select on npg_file to tiptopgp;
grant update on npg_file to tiptopgp;
grant delete on npg_file to tiptopgp;
grant insert on npg_file to tiptopgp;
grant index on npg_file to public;
grant select on npg_file to ods;
