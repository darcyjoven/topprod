/*
================================================================================
檔案代號:tc_tlf_file
檔案名稱:客制成本推算明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_tlf_file
(
tc_tlf01    varchar2(4),             /*年度                                   */
tc_tlf02    varchar2(4),             /*期别                                   */
tc_tlf03    varchar2(50),            /*料件编号                               */
tc_tlf04    date,                    /*异动日期                               */
tc_tlf05    varchar2(40),            /*异动单号                               */
tc_tlf06    number(5),               /*异动项次                               */
tc_tlf07    number(5),               /*异动类型                               */
                                     /*1表示入库  -1表示出库                  */
tc_tlf08    number(20,6),            /*入库量                                 */
tc_tlf09    number(20,6),            /*入库单价                               */
tc_tlf10    number(20,6),            /*出库量                                 */
tc_tlf11    number(20,6),            /*出库单价                               */
tc_tlf12    varchar2(10),            /*异动单价                               */
tc_tlf13    number(16,8),            /*异动单位转换率                         */
tc_tlf14    varchar2(20),            /*异动指令                               */
                                     /*tlf13                                  */
tc_tlf15    varchar2(1),             /*完工入库对应工单类型                   */
tc_tlf16    varchar2(10)             /*杂收发异动理由码                       */
);

grant select on tc_tlf_file to tiptopgp;
grant update on tc_tlf_file to tiptopgp;
grant delete on tc_tlf_file to tiptopgp;
grant insert on tc_tlf_file to tiptopgp;
grant index on tc_tlf_file to public;
grant select on tc_tlf_file to ods;
