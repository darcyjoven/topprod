/*
================================================================================
檔案代號:tc_ofa_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_ofa_file
(
tc_ofa01    varchar2(20),            /*forcast订单单号                        */
tc_ofa02    date,                    /*单据日期                               */
tc_ofa03    varchar2(10),            /*客户编号                               */
tc_ofa04    varchar2(10),            /*业务原                                 */
tc_ofa05    varchar2(1),             /*资料来源                               */
tc_ofa06    varchar2(20),            /*来源单号                               */
tc_ofa07    varchar2(1),             /*状况码                                 */
tc_ofa08    date,                    /*审核日期                               */
tc_ofa09    varchar2(1),             /*结案否                                 */
tc_ofa10    date,                    /*结案日期                               */
tc_ofa11    varchar2(1000),          /*备注                                   */
tc_ofa12    varchar2(20),            /*签核否                                 */
tc_ofa13    varchar2(20),            /*签核状态                               */
tc_ofa14    varchar2(20),
tc_ofa15    number(10),
tc_ofa16    number(10),
tc_ofa17    number(10),
tc_ofa18    number(10),
tc_ofa19    date,
tc_ofa20    date,
tc_ofauser  varchar2(10),
tc_ofagrup  varchar2(10),
tc_ofaoriu  varchar2(10),
tc_ofaorig  varchar2(10),
tc_ofamodu  varchar2(10),
tc_ofadate  date
);

grant select on tc_ofa_file to tiptopgp;
grant update on tc_ofa_file to tiptopgp;
grant delete on tc_ofa_file to tiptopgp;
grant insert on tc_ofa_file to tiptopgp;
grant index on tc_ofa_file to public;
grant select on tc_ofa_file to ods;
