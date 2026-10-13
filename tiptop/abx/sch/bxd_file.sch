/*
================================================================================
檔案代號:bxd_file
檔案名稱:保税受托加工原料料件月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bxd_file
(
bxd01       varchar2(40) NOT NULL,   /*料件编号                               */
bxd03       number(5) NOT NULL,      /*年度                                   */
bxd04       number(5) NOT NULL,      /*月份                                   */
bxd05       varchar2(20) NOT NULL,   /*订单单号                               */
bxd06       number(5) NOT NULL,      /*订单项次                               */
bxd07       number(15,3) NOT NULL,   /*本期杂收总量                           */
bxd08       number(15,3) NOT NULL,   /*本期杂发总量                           */
bxd09       number(15,3) NOT NULL,   /*本期报废总量                           */
bxd10       number(15,3) NOT NULL,   /*本期工单发料总量                       */
bxd11       number(15,3) NOT NULL,   /*本期工单退料总量                       */
bxd12       number(15,3) NOT NULL,   /*本期完工入库总量                       */
bxd13       number(15,3) NOT NULL,   /*本期采购入库总量                       */
bxd14       number(15,3) NOT NULL,   /*本期采购仓退总量                       */
bxd15       number(15,3) NOT NULL,   /*本期销货总量                           */
bxd16       number(15,3) NOT NULL,   /*本期销货退回总量                       */
bxd17       number(15,3) NOT NULL,   /*本期其它异动总量                       */
bxd18       number(15,3) NOT NULL,   /*期末数量                               */
bxdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bxdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index bxd_02 on bxd_file (bxd05,bxd06);
alter table bxd_file add  constraint bxd_pk primary key  (bxd01,bxd03,bxd04,bxd05,bxd06) enable validate;
grant select on bxd_file to tiptopgp;
grant update on bxd_file to tiptopgp;
grant delete on bxd_file to tiptopgp;
grant insert on bxd_file to tiptopgp;
grant index on bxd_file to public;
grant select on bxd_file to ods;
