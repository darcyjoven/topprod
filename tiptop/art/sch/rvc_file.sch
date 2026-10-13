/*
================================================================================
檔案代號:rvc_file
檔案名稱:对账单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvc_file
(
rvc00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
                                     /*Doc. Type                              */
rvc01       varchar2(20) DEFAULT ' ' NOT NULL, /*对账单号*/
rvc02       varchar2(1),             /*经营方式                               */
                                     /*Running Mode 1:Sell 2:Sell Goods On a Commission Basis (Cost) */
                                     /*3:Sell Goods On a Commission Basis (Deduction%) 4:Pool*/
rvc03       varchar2(10),            /*供应商                                 */
rvc04       date,                    /*对账开始日期                           */
rvc05       date,                    /*对账结束日期                           */
rvc06       varchar2(255),           /*備注                                   */
rvcacti     varchar2(1),             /*资料有效码                             */
rvccond     date,                    /*审核日期                               */
rvcconf     varchar2(1),             /*审核码                                 */
rvcconu     varchar2(10),            /*审核人员                               */
rvccrat     date,                    /*资料创建日                             */
rvcdate     date,                    /*最近更改日                             */
rvcgrup     varchar2(10),            /*资料所有部门                           */
rvclegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvcmodu     varchar2(10),            /*资料更改者                             */
rvcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvcuser     varchar2(10),            /*资料所有者                             */
rvcorig     varchar2(10),            /*资料建立部门                           */
rvcoriu     varchar2(10)             /*资料建立者                             */
);

alter table rvc_file add  constraint rvc_pk primary key  (rvc00,rvc01) enable validate;
grant select on rvc_file to tiptopgp;
grant update on rvc_file to tiptopgp;
grant delete on rvc_file to tiptopgp;
grant insert on rvc_file to tiptopgp;
grant index on rvc_file to public;
grant select on rvc_file to ods;
