/*
================================================================================
檔案代號:azl_file
檔案名稱:EasyFlow签核上传附件资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table azl_file
(
azl01       varchar2(20),            /*送签单号                               */
                                     /*送簽單號                               */
azl02       varchar2(80),            /*附件档档径名                           */
                                     /*附件檔檔徑名                           */
azl03       varchar2(1),             /*No Use                                 */
azl04       varchar2(1),             /*No Use                                 */
azl05       varchar2(1),             /*No Use                                 */
azl06       varchar2(1),             /*No Use                                 */
azl07       varchar2(1),             /*No Use                                 */
azlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
azllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index azl_01 on azl_file (azl01);
grant select on azl_file to tiptopgp;
grant update on azl_file to tiptopgp;
grant delete on azl_file to tiptopgp;
grant insert on azl_file to tiptopgp;
grant index on azl_file to public;
grant select on azl_file to ods;
