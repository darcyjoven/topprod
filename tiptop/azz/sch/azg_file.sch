/*
================================================================================
檔案代號:azg_file
檔案名稱:EasyFlow簽核記錄檔(由easyFlow回寫)
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table azg_file
(
azg01       varchar2(80),            /*送签单号                               */
                                     /*送簽單號                               */
azg02       varchar2(10),            /*异动日期                               */
                                     /*異動日期                               */
azg03       varchar2(8),             /*异动时间                               */
                                     /*異動時間                               */
azg04       varchar2(1),             /*签核状态                               */
                                     /*簽核狀態                               */
                                     /*1.送簽                                 */
                                     /*2.抽單                                 */
                                     /*3.同意                                 */
                                     /*4.不同意                               */
azg05       varchar2(10),            /*人员名称                               */
                                     /*人員名稱                               */
azg06       varchar2(32),            /*EasyFlow 单号                          */
                                     /*EasyFlow單號                           */
azg07       varchar2(256),           /*签核意见                               */
                                     /*簽核意見                               */
azg08       varchar2(30),            /*EasyFlow单别                           */
azg09       varchar2(20),            /*程序代码                               */
azgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
azglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index azg_01 on azg_file (azg01,azg09);
grant select on azg_file to tiptopgp;
grant update on azg_file to tiptopgp;
grant delete on azg_file to tiptopgp;
grant insert on azg_file to tiptopgp;
grant index on azg_file to public;
grant select on azg_file to ods;
