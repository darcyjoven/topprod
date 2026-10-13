/*
================================================================================
檔案代號:tc_mss_file
檔案名稱:采购需求总表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_mss_file
(
tc_mss01    varchar2(40) NOT NULL,   /*采购需求版本号                         */
tc_mss02    varchar2(40) NOT NULL,   /*料件编号                               */
tc_mss03    varchar2(120),           /*品名                                   */
tc_mss04    varchar2(120),           /*规格                                   */
tc_mss05    varchar2(4),             /*库存单位                               */
tc_mss06    number(15,3),            /*建议请购量                             */
tc_mss07    number(15,3),            /*库房正常仓数量                         */
tc_mss08    number(15,3),            /*库房呆品仓数量                         */
tc_mss09    number(15,3),            /*IQC数量                                */
tc_mss10    number(15,3),            /*采购未交数量                           */
tc_mss11    number(15,3),            /*请购待采购数量                         */
tc_mss12    number(15,3),            /*待杂收数量                             */
tc_mss13    number(15,3),            /*待杂发数量                             */
tc_mss14    number(15,3),            /*工单未领数量                           */
tc_mss15    number(15,3),            /*备料需求数                             */
tc_mss16    number(15,3),            /*安全存量                               */
tc_mss17    number(15,3),            /*单位包装量                             */
tc_mss18    varchar2(1),             /*资料有效否                             */
tc_mss19    date,                    /*版本日期                               */
tc_mss20    date,                    /*NO USE                                 */
tc_mss21    varchar2(40),            /*版本时间                               */
tc_mss22    varchar2(40),            /*NO USE                                 */
tc_mss23    varchar2(40),            /*NO USE                                 */
tc_mss24    varchar2(40),            /*NO USE                                 */
tc_mss25    varchar2(40),            /*NO USE                                 */
tc_mssud01  number(15,3),            /*自定义字段一                           */
tc_mssud02  number(15,3),            /*自定义字段二                           */
tc_mssud03  number(15,3),            /*自定义字段三                           */
tc_mssud04  number(15,3),            /*自定义字段四                           */
tc_mssud05  number(15,3)             /*自定义字段五                           */
);

create        index tic_mss_01 on tc_mss_file (tc_mss01,tc_mss02);
alter table tc_mss_file add  constraint tpc_mss_pk primary key  (tc_mss01,tc_mss02) enable validate;
grant select on tc_mss_file to tiptopgp;
grant update on tc_mss_file to tiptopgp;
grant delete on tc_mss_file to tiptopgp;
grant insert on tc_mss_file to tiptopgp;
grant index on tc_mss_file to public;
grant select on tc_mss_file to ods;
