/*
================================================================================
檔案代號:tc_bmi_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_bmi_file
(
tc_bmi01    varchar2(20) NOT NULL,   /*良率单号                               */
tc_bmi02    date,                    /*单据日期                               */
tc_bmi03    varchar2(10),            /*申请部门                               */
tc_bmi04    varchar2(255),           /*备注                                   */
tc_bmi05    varchar2(1),
tc_bmi06    varchar2(1),             /*状况码                                 */
tc_bmi07    varchar2(1),             /*签核否                                 */
tc_bmiconf  varchar2(1),             /*确认码                                 */
tc_bmiacti  varchar2(1),             /*资料有效码                             */
tc_bmiuser  varchar2(10),            /*资料所有者                             */
tc_bmigrup  varchar2(10),            /*资料更改者                             */
tc_bmimodu  varchar2(10),            /*最近更改日                             */
tc_bmidate  date,
tc_bmi08    varchar2(4),
tc_bmi081   number(9,4),
tc_bmi09    varchar2(10),            /*申请人                                 */
tc_bmi10    varchar2(1),
tc_bmiplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_bmilegal varchar2(10) NOT NULL,   /*所属法人                               */
tc_bmioriu  varchar2(10),            /*资料建立者                             */
tc_bmiorig  varchar2(10)             /*资料建立部门                           */
);

grant select on tc_bmi_file to tiptopgp;
grant update on tc_bmi_file to tiptopgp;
grant delete on tc_bmi_file to tiptopgp;
grant insert on tc_bmi_file to tiptopgp;
grant index on tc_bmi_file to public;
grant select on tc_bmi_file to ods;
