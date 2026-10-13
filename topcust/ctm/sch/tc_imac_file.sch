/*
================================================================================
檔案代號:tc_imac_file
檔案名稱:地址维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imac_file
(
tc_imac01   varchar2(20) NOT NULL,   /*流水号                                 */
tc_imac02   varchar2(1000),          /*省                                     */
tc_imac03   varchar2(1000),          /*市                                     */
tc_imac04   varchar2(1000),          /*区/县                                  */
tc_imac05   varchar2(1000),          /*地址                                   */
tc_imac06   varchar2(1000),          /*姓名                                   */
tc_imac07   varchar2(1000),          /*电话                                   */
tc_imac08   varchar2(1),             /*是否默认地址                           */
                                     /*Y/N                                    */
tc_imac09   varchar2(1),             /*标识                                   */
                                     /*1.新增,2.修改                          */
tc_imac10   varchar2(20),            /*员工编码                               */
tc_imac11   date,                    /*日期                                   */
tc_imac12   varchar2(8)              /*时间                                   */
);

alter table tc_imac_file add  constraint tpc_imac_pk primary key  (tc_imac01) enable validate;
grant select on tc_imac_file to tiptopgp;
grant update on tc_imac_file to tiptopgp;
grant delete on tc_imac_file to tiptopgp;
grant insert on tc_imac_file to tiptopgp;
grant index on tc_imac_file to public;
grant select on tc_imac_file to ods;
