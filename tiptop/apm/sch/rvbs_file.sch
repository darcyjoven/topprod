/*
================================================================================
檔案代號:rvbs_file
檔案名稱:入库序号明细
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvbs_file
(
rvbs00      varchar2(10) NOT NULL,   /*类型                                   */
rvbs01      varchar2(20) NOT NULL,   /*入库单号                               */
rvbs02      number(5) NOT NULL,      /*项次                                   */
rvbs03      varchar2(30) DEFAULT ' ' NOT NULL, /*序号*/
rvbs04      varchar2(30) DEFAULT ' ' NOT NULL, /*制造批号*/
rvbs05      date,                    /*厂商制造日期                           */
rvbs06      number(15,3),            /*数量                                   */
rvbs07      varchar2(1),             /*归属类型                               */
rvbs08      varchar2(20) NOT NULL,   /*归属单号                               */
rvbs021     varchar2(40),            /*料件编号                               */
rvbs022     number(5) DEFAULT '0' NOT NULL, /*项次*/
rvbs09      number(5) NOT NULL,      /*属性                                   */
rvbs10      number(15,3),            /*允收数量                               */
rvbs11      number(15,3),            /*入库量                                 */
rvbs12      number(15,3),            /*退货量                                 */
rvbs13      number(5) NOT NULL,      /*检验批号                               */
rvbsplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
rvbslegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rvbs_file add  constraint rvbs_pk primary key  (rvbs00,rvbs01,rvbs02,rvbs022,rvbs09,rvbs13) enable validate;
grant select on rvbs_file to tiptopgp;
grant update on rvbs_file to tiptopgp;
grant delete on rvbs_file to tiptopgp;
grant insert on rvbs_file to tiptopgp;
grant index on rvbs_file to public;
grant select on rvbs_file to ods;
