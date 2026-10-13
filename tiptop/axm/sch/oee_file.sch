/*
================================================================================
檔案代號:oee_file
檔案名稱:订单底稿分配档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oee_file
(
oee01       varchar2(20),            /*订单底稿编号                           */
oee02       number(5),               /*订单底稿项次                           */
oee03       varchar2(8),             /*内部流程代码                           */
oee04       varchar2(10),            /*出货营运中心                           */
oee05       date,                    /*预计交货日                             */
oee061      varchar2(4),             /*单位一                                 */
oee062      number(20,8),            /*单位一换算率                           */
oee063      number(15,3),            /*单位一数量                             */
oee071      varchar2(4),             /*单位二                                 */
oee072      number(20,8),            /*单位二换算率                           */
oee073      number(15,3),            /*单位二数量                             */
oee081      varchar2(4),             /*销售单位                               */
oee082      number(20,8),            /*销售库存换算率                         */
oee083      number(15,3),            /*销售数量                               */
oee09       varchar2(5),             /*缺省单别                               */
oee10       varchar2(20),            /*单据编号                               */
oee11       number(5),               /*单据项次                               */
oeeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oeelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index oee_01 on oee_file (oee01,oee02);
grant select on oee_file to tiptopgp;
grant update on oee_file to tiptopgp;
grant delete on oee_file to tiptopgp;
grant insert on oee_file to tiptopgp;
grant index on oee_file to public;
grant select on oee_file to ods;
