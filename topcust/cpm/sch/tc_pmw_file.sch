/*
================================================================================
檔案代號:tc_pmw_file
檔案名稱:询价单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_pmw_file
(
tc_pmw01    varchar2(20) NOT NULL,   /*询价单号                               */
tc_pmw02    date,                    /*询价日期                               */
tc_pmw03    varchar2(10),            /*币种                                   */
tc_pmw04    varchar2(40),            /*备注                                   */
tc_pmw05    varchar2(100),
tc_pmw06    varchar2(1),             /*状况码                                 */
tc_pmw07    varchar2(1),             /*签核否                                 */
tc_pmwconf  varchar2(1),             /*确认码                                 */
tc_pmwacti  varchar2(1),             /*资料有效码                             */
tc_pmwuser  varchar2(10),            /*资料所有者                             */
tc_pmwgrup  varchar2(10),            /*资料所有部门                           */
tc_pmwmodu  varchar2(10),            /*资料修改者                             */
tc_pmwdate  date,                    /*最近修改日                             */
tc_pmw08    varchar2(4),             /*税别                                   */
tc_pmw081   number(9,4),             /*税率                                   */
tc_pmw09    varchar2(10),            /*申请人                                 */
tc_pmw10    varchar2(1),             /*价格形态                               */
tc_pmwplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_pmwlegal varchar2(10) NOT NULL,   /*所属法人                               */
tc_pmworiu  varchar2(10),            /*资料建立者                             */
tc_pmworig  varchar2(10)             /*资料建立部门                           */
);

grant select on tc_pmw_file to tiptopgp;
grant update on tc_pmw_file to tiptopgp;
grant delete on tc_pmw_file to tiptopgp;
grant insert on tc_pmw_file to tiptopgp;
grant index on tc_pmw_file to public;
grant select on tc_pmw_file to ods;
