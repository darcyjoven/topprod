/*
================================================================================
檔案代號:vzw_file
檔案名稱:aps伺服器命令伫列档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vzw_file
(
vzw00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vzw01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vzw02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vzw03       varchar2(60),            /*指令                                   */
vzw04       varchar2(60),            /*参数1(plant)                           */
vzw05       varchar2(60),            /*参数2(Limited Version)                 */
vzw06       varchar2(60),            /*参数3(mrp Version)                     */
vzw07       varchar2(60),            /*参数4(user_id)                         */
vzw08       varchar2(60),            /*参数5(erp)                             */
vzw09       varchar2(60),            /*参数6                                  */
vzw10       varchar2(60),            /*参数7                                  */
vzw11       varchar2(60),            /*参数8                                  */
vzw12       number(1),               /*运行状态                               */
vzw13       date                     /*维护时间                               */
);

alter table vzw_file add  constraint vzw_pk primary key  (vzw00,vzw01,vzw02) enable validate;
grant select on vzw_file to tiptopgp;
grant update on vzw_file to tiptopgp;
grant delete on vzw_file to tiptopgp;
grant insert on vzw_file to tiptopgp;
grant index on vzw_file to public;
grant select on vzw_file to ods;
