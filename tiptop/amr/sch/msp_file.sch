/*
================================================================================
檔案代號:msp_file
檔案名稱:MRP限定版别
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msp_file
(
msp01       varchar2(10) NOT NULL,   /*版本编号                               */
                                     /*版本編號                               */
msp02       number(5) NOT NULL,      /*版本序号                               */
                                     /*版本序號                               */
msp03       varchar2(10),            /*仓库                                   */
                                     /*倉庫                                   */
msp04       varchar2(5),             /*单别                                   */
                                     /*單別                                   */
msp05       varchar2(10),            /*指送地址                               */
msp06       varchar2(1),             /*No Use                                 */
msp07       varchar2(1),             /*No Use                                 */
msp08       varchar2(1),             /*No Use                                 */
msp09       number(5),               /*No Use                                 */
msp10       number(1) DEFAULT '0' NOT NULL /*限定条件选择*/
);

alter table msp_file add  constraint msp_pk primary key  (msp01,msp02) enable validate;
grant select on msp_file to tiptopgp;
grant update on msp_file to tiptopgp;
grant delete on msp_file to tiptopgp;
grant insert on msp_file to tiptopgp;
grant index on msp_file to public;
grant select on msp_file to ods;
