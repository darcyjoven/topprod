/*
================================================================================
檔案代號:azv_file
檔案名稱:料件承认更改记录
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table azv_file
(
azv01       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
azv02       varchar2(24),            /*制造商                                 */
                                     /*製造商                                 */
azv03       varchar2(10),            /*供应商                                 */
                                     /*供應商                                 */
azv04       varchar2(10),            /*承认文号                               */
                                     /*承認文號                               */
azv05       date,                    /*承认日期                               */
                                     /*承認日期                               */
azv06       varchar2(1),             /*承认状态                               */
                                     /*Approval Status 0.Sample Sent 1.Testing 2.Countersign 3.Approved*/
azv07       varchar2(10),            /*异动人员                               */
                                     /*異動人員                               */
azv08       date,                    /*异动日期                               */
                                     /*異動日期                               */
azv09       varchar2(10),            /*异动时间                               */
                                     /*異動時間                               */
azv10       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
azvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
azvlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index azv_02 on azv_file (azv09);
create        index azv_01 on azv_file (azv01,azv02,azv07);
grant select on azv_file to tiptopgp;
grant update on azv_file to tiptopgp;
grant delete on azv_file to tiptopgp;
grant insert on azv_file to tiptopgp;
grant index on azv_file to public;
grant select on azv_file to ods;
