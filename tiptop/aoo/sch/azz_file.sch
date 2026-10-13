/*
================================================================================
檔案代號:azz_file
檔案名稱:多营运中心控制参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azz_file
(
azz01       varchar2(1) NOT NULL,    /*KEY VALUE (0)                          */
azz02       varchar2(1),             /*是否为多营运中心环境                   */
                                     /*是否為多工廠環境 (Y/N)                 */
azz03       varchar2(10),            /*若非多营运中心环境时缺省营             */
                                     /*若非多工廠環境時預設工廠編號           */
azz04       varchar2(20),            /*若非多营运中心环境时缺省数             */
                                     /*若非多工廠環境時預設資料庫編號         */
azz05       varchar2(1),             /*营运中心分散于不同时区. 启             */
                                     /*No Use                                 */
azz06       varchar2(1),             /*启用资料库登入账号密码编码             */
azz07       varchar2(1),             /*No Use                                 */
azz08       varchar2(1),             /*No Use                                 */
azz09       varchar2(1),             /*No Use                                 */
azz10       varchar2(1),             /*No Use                                 */
azz11       varchar2(1),
azz12       varchar2(1),
azz13       varchar2(80),
azz14       varchar2(1),
azz15       varchar2(1),
azz16       varchar2(1),
azz17       varchar2(1),
azz18       varchar2(1) DEFAULT 'N' NOT NULL, /*启动Web Service 传送资安字段*/
azz19       varchar2(1) DEFAULT 'N' NOT NULL /*启用外部日志*/
);

alter table azz_file add  constraint azz_pk primary key  (azz01) enable validate;
grant select on azz_file to tiptopgp;
grant update on azz_file to tiptopgp;
grant delete on azz_file to tiptopgp;
grant insert on azz_file to tiptopgp;
grant index on azz_file to public;
grant select on azz_file to ods;
