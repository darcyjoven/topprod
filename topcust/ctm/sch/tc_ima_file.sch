/*
================================================================================
檔案代號:tc_ima_file
檔案名稱:销售资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ima_file
(
tc_ima01    varchar2(40) NOT NULL,   /*品号                                   */
tc_ima02    varchar2(1000),          /*品牌                                   */
tc_ima03    varchar2(1000),          /*型号                                   */
tc_ima04    date,                    /*上市时间                               */
tc_ima05    varchar2(1000),          /*网络类型                               */
tc_ima06    varchar2(1000),          /*款式                                   */
tc_ima07    varchar2(1000),          /*后置摄像头                             */
tc_ima08    varchar2(1000),          /*机身厚度                               */
tc_ima09    varchar2(1000),          /*售后服务                               */
tc_ima10    varchar2(1000),          /*电池类型                               */
tc_ima11    varchar2(1000),          /*电池容量                               */
tc_ima12    varchar2(1000),          /*分辨率                                 */
tc_ima13    varchar2(1000),          /*摄像头性质                             */
tc_ima14    varchar2(1000),          /*版本类型                               */
tc_ima15    number(15,3)             /*价格                                   */
);

alter table tc_ima_file add  constraint tpc_ima_pk primary key  (tc_ima01) enable validate;
grant select on tc_ima_file to tiptopgp;
grant update on tc_ima_file to tiptopgp;
grant delete on tc_ima_file to tiptopgp;
grant insert on tc_ima_file to tiptopgp;
grant index on tc_ima_file to public;
grant select on tc_ima_file to ods;
