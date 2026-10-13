/*
================================================================================
檔案代號:tc_imab_file
檔案名稱:购物车资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imab_file
(
tc_imab01   varchar2(40),            /*品号                                   */
tc_imab02   varchar2(1000),          /*品牌                                   */
tc_imab03   varchar2(1000),          /*型号                                   */
tc_imab04   date,                    /*上市时间                               */
tc_imab05   varchar2(1000),          /*网络类型                               */
tc_imab06   varchar2(1000),          /*款式                                   */
tc_imab07   varchar2(1000),          /*后置摄像头                             */
tc_imab08   varchar2(1000),          /*机身厚度                               */
tc_imab09   varchar2(1000),          /*售后服务                               */
tc_imab10   varchar2(1000),          /*电池类型                               */
tc_imab11   varchar2(1000),          /*电池容量                               */
tc_imab12   varchar2(1000),          /*分辨率                                 */
tc_imab13   varchar2(1000),          /*摄像头性质                             */
tc_imab14   varchar2(1000),          /*版本类型                               */
tc_imab15   number(15,3),            /*价格                                   */
tc_imab16   number(10),              /*数量                                   */
tc_imab17   varchar2(1000),          /*人员编码                               */
tc_imab18   varchar2(40) NOT NULL,   /*单号                                   */
tc_imab19   varchar2(1),             /*状态                                   */
tc_imab20   date,                    /*日期                                   */
tc_imab21   varchar2(8)              /*时间                                   */
);

alter table tc_imab_file add  constraint tpc_imab_pk primary key  (tc_imab18) enable validate;
grant select on tc_imab_file to tiptopgp;
grant update on tc_imab_file to tiptopgp;
grant delete on tc_imab_file to tiptopgp;
grant insert on tc_imab_file to tiptopgp;
grant index on tc_imab_file to public;
grant select on tc_imab_file to ods;
