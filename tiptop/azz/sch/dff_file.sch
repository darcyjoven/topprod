/*
================================================================================
檔案代號:dff_file
檔案名稱:数据库比对结果档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table dff_file
(
dff01       varchar2(10),            /*版本编号                               */
                                     /*版本代號                               */
dff02       number(5),               /*差异类型                               */
                                     /*差異類別                               */
                                     /*1:table not found in target            */
                                     /*2:table not found in source            */
                                     /*3:field not found in target            */
                                     /*4:field not found in source            */
                                     /*5:field data type not match            */
                                     /*6:field data length not match          */
dff03       varchar2(20),            /*source db name                         */
                                     /*source db name ==>  如ds               */
dff04       varchar2(20),            /*target db name                         */
                                     /*target db name ==>  如ds3              */
dff05       varchar2(18),            /*table name in source db                */
                                     /*table name in source db ==>  如aoo_file*/
dff06       varchar2(18),            /*table name in target db                */
                                     /*table name in target db ==>  如azz_file*/
dff07       varchar2(18),            /*field name in source db                */
                                     /*field name in source db ==>  如oma11   */
dff08       varchar2(18),            /*field name in target db                */
                                     /*field name in target db ==>  如oga20   */
dff09       varchar2(20),            /*different data type in source db       */
dff10       varchar2(20),            /*different data type in target db       */
dff11       varchar2(10),            /*different data length in source db     */
dff12       varchar2(10),            /*different data length in target db     */
dff13       varchar2(18),            /*next field name in source              */
dff14       varchar2(18),            /*next filed name in target              */
dff15       date                     /*比对日期                               */
                                     /*比對日期                               */
);

grant select on dff_file to tiptopgp;
grant update on dff_file to tiptopgp;
grant delete on dff_file to tiptopgp;
grant insert on dff_file to tiptopgp;
grant index on dff_file to public;
grant select on dff_file to ods;
