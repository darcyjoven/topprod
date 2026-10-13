/*
================================================================================
檔案代號:run_file
檔案名稱:样品入场/退场单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table run_file
(
run00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型1-入场单2-退场单*/
run01       varchar2(20) DEFAULT ' ' NOT NULL,
run02       number(5) DEFAULT '0' NOT NULL, /*项次*/
run03       varchar2(40),            /*产品编号                               */
run04       varchar2(4),             /*库存单位                               */
run05       varchar2(40),            /*产品条码                               */
run06       varchar2(4),
run07       number(16,8),            /*换算率                                 */
run08       number(15,3) DEFAULT '0' NOT NULL,
run09       number(15,3) DEFAULT '0' NOT NULL,
run10       number(15,3) DEFAULT '0' NOT NULL,
run11       varchar2(10),            /*仓库                                   */
run12       varchar2(10),            /*库位                                   */
run13       varchar2(24),            /*批号                                   */
runlegal    varchar2(10) NOT NULL,   /*所属法人                               */
runplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table run_file add  constraint run_pk primary key  (run00,run01,run02,runplant) enable validate;
grant select on run_file to tiptopgp;
grant update on run_file to tiptopgp;
grant delete on run_file to tiptopgp;
grant insert on run_file to tiptopgp;
grant index on run_file to public;
grant select on run_file to ods;
