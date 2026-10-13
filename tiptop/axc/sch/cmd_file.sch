/*
================================================================================
檔案代號:cmd_file
檔案名稱:净变现单价计算档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cmd_file
(
cmd01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*NO USE(FUN-920130)                     */
cmd02       number(5) NOT NULL,      /*年度                                   */
                                     /*NO USE(FUN-920130)                     */
cmd03       number(5) NOT NULL,      /*月份                                   */
                                     /*NO USE(FUN-920130)                     */
cmd04       varchar2(1),             /*计算类型                               */
                                     /*NO USE(FUN-920130)                     */
cmd05       number(20,6),            /*净变现单价                             */
                                     /*NO USE(FUN-920130)                     */
cmd06       number(20,6),            /*市价                                   */
                                     /*NO USE(FUN-920130)                     */
cmd07       varchar2(20),            /*参考单号                               */
                                     /*NO USE(FUN-920130)                     */
cmd08       number(5),               /*参考项次                               */
                                     /*NO USE(FUN-920130)                     */
cmd10       varchar2(1),             /*逆推顺序                               */
                                     /*NO USE(FUN-920130)                     */
cmd11       varchar2(1),             /*销售费用率类型                         */
                                     /*NO USE(FUN-920130)                     */
cmd12       number(15,3),            /*销售费用率                             */
                                     /*NO USE(FUN-920130)                     */
cmd09       varchar2(40),            /*逆推成品料号                           */
                                     /*NO USE(FUN-920130)                     */
cmdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cmd_file add  constraint cmd_pk primary key  (cmd01,cmd02,cmd03) enable validate;
grant select on cmd_file to tiptopgp;
grant update on cmd_file to tiptopgp;
grant delete on cmd_file to tiptopgp;
grant insert on cmd_file to tiptopgp;
grant index on cmd_file to public;
grant select on cmd_file to ods;
