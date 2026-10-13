/*
================================================================================
檔案代號:zs_file
檔案名稱:档案架构修整记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zs_file
(
zs01        varchar2(15) NOT NULL,   /*档案编号                               */
                                     /*檔案編號                               */
zs02        varchar2(20) NOT NULL,   /*数据库                                 */
                                     /*資料庫                                 */
zs03        number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
zs04        date,                    /*修正日期                               */
zs05        varchar2(1),             /*属性                                   */
                                     /*屬性                                   */
zs06        varchar2(4000) DEFAULT ' ', /*修正指令及说明*/
                                     /*修正指令及說明                         */
zs07        varchar2(10),            /*修正人                                 */
zs08        varchar2(25),            /*p_zl 工作单号                          */
                                     /*p_zl 工作單號                          */
zs09        varchar2(1),             /*测试区                                 */
                                     /*測試區                                 */
zs10        varchar2(1),             /*正式区                                 */
                                     /*正式區                                 */
zs11        varchar2(1),             /*正式成功否                             */
zs12        varchar2(7)              /*版本号码                               */
                                     /*版本號碼                               */
);

alter table zs_file add  constraint zs_pk primary key  (zs01,zs02,zs03) enable validate;
grant select on zs_file to tiptopgp;
grant update on zs_file to tiptopgp;
grant delete on zs_file to tiptopgp;
grant insert on zs_file to tiptopgp;
grant index on zs_file to public;
grant select on zs_file to ods;
