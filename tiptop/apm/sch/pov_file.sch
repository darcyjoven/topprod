/*
================================================================================
檔案代號:pov_file
檔案名稱:关系人内部交易基本设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pov_file
(
pov01       varchar2(1) DEFAULT ' ' NOT NULL, /*资料性质*/
pov02       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商/客户编号*/
pov03       varchar2(10),            /*对应的营运中心编号                     */
pov04       varchar2(10),            /*仓库                                   */
pov05       varchar2(1),             /*AP类型                                 */
pov06       varchar2(10),            /*AR科目                                 */
pov07       varchar2(10),            /*AP科目                                 */
pov08       varchar2(10),            /*AR部门编号                             */
pov09       varchar2(10),            /*AP部门编号                             */
pov10       varchar2(1),             /*营业额申报方式                         */
pov11       varchar2(1),             /*是否计算业绩                           */
pov12       varchar2(10),            /*调拨理由码                             */
pov13       varchar2(5),             /*订单单别                               */
pov14       varchar2(5),             /*采购单单别                             */
pov15       varchar2(5),             /*出货单单别                             */
pov16       varchar2(5),             /*收货单单别                             */
pov17       varchar2(5),             /*入库单单别                             */
pov18       varchar2(5),             /*AR单别                                 */
pov19       varchar2(5),             /*AP单别                                 */
pov20       varchar2(5),             /*销退单单别                             */
pov21       varchar2(5),             /*仓退单单别                             */
pov22       varchar2(5),             /*AR折让单别                             */
pov23       varchar2(5),             /*AP折让单别                             */
pov24       varchar2(10),            /*订单成本中心                           */
pov25       varchar2(10),            /*采购成本中心                           */
pov26       varchar2(5),             /*出货通知单别                           */
pov27       varchar2(10),            /*当前营运中心在对应营运中心             */
pov28       varchar2(10)             /*当前营运中心在对应营运中心             */
);

alter table pov_file add  constraint pov_pk primary key  (pov01,pov02) enable validate;
grant select on pov_file to tiptopgp;
grant update on pov_file to tiptopgp;
grant delete on pov_file to tiptopgp;
grant insert on pov_file to tiptopgp;
grant index on pov_file to public;
grant select on pov_file to ods;
