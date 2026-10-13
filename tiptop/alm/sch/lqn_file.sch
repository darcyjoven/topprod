/*
================================================================================
檔案代號:lqn_file
檔案名稱:券回收记录单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqn_file
(
lqn00       varchar2(10),            /*原门店编号                             */
lqn01       varchar2(20) DEFAULT ' ' NOT NULL, /*券回收单号*/
lqn02       varchar2(20),            /*退货单编号                             */
lqn03       varchar2(20),            /*销售单编号                             */
lqn04       varchar2(20),            /*退货凭证编号                           */
lqn05       number(20,6),            /*退货总金额                             */
lqn06       date,                    /*券回收日期                             */
lqn07       number(20,6),            /*券回收金额                             */
lqn071      number(20,6),            /*实回收券金额                           */
lqn08       number(20,6),            /*总赔偿金额                             */
lqn09       varchar2(1),             /*审核码                                 */
lqn10       varchar2(10),            /*审核人                                 */
lqn11       date,                    /*审核日期                               */
lqn12       varchar2(255),           /*备注                                   */
lqn13       varchar2(1),             /*no use                                 */
lqncrat     date,                    /*资料创建日                             */
lqndate     date,                    /*最近更改日                             */
lqngrup     varchar2(10),            /*资料所有群                             */
lqnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lqnmodu     varchar2(10),            /*资料更改者                             */
lqnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lqnuser     varchar2(10),            /*资料所有者                             */
lqnoriu     varchar2(10),            /*资料建立者                             */
lqnorig     varchar2(10)             /*资料建立部门                           */
);

alter table lqn_file add  constraint lqn_pk primary key  (lqn01) enable validate;
grant select on lqn_file to tiptopgp;
grant update on lqn_file to tiptopgp;
grant delete on lqn_file to tiptopgp;
grant insert on lqn_file to tiptopgp;
grant index on lqn_file to public;
grant select on lqn_file to ods;
