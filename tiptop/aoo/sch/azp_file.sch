/*
================================================================================
檔案代號:azp_file
檔案名稱:营运中心主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azp_file
(
azp01       varchar2(10) NOT NULL,   /*营运中心代码                           */
                                     /*工廠編號                               */
azp02       varchar2(80),            /*营运中心名称                           */
                                     /*工廠名稱                               */
azp03       varchar2(20),            /*数据库代码                             */
                                     /*資料庫代碼                             */
azp04       varchar2(10),            /*服务器(SERVER)编号                     */
                                     /*伺服器(SERVER)編號 (No use)            */
azp051      varchar2(255),           /*地址-1                                 */
                                     /*地址-1      no.7431 #genero 改為TEXTEDIT*/
azp052      varchar2(80),            /*时区                                   */
                                     /*時區                 ex:GMT-1          */
azp053      varchar2(1),             /*ERP 数据库否                           */
                                     /*ERP 資料庫否         no.7431           */
azp06       varchar2(40),            /*营运中心电话                           */
                                     /*工廠電話                               */
azp07       varchar2(40),            /*营运中心传真                           */
                                     /*工廠傳真                               */
azp08       varchar2(1),             /*No Use                                 */
azp09       varchar2(1),             /*是否限制上线人数                       */
azp10       number(10),              /*可上线人数                             */
azp20       varchar2(20)
);

alter table azp_file add  constraint azp_pk primary key  (azp01) enable validate;
grant select on azp_file to tiptopgp;
grant update on azp_file to tiptopgp;
grant delete on azp_file to tiptopgp;
grant insert on azp_file to tiptopgp;
grant index on azp_file to public;
grant select on azp_file to ods;
