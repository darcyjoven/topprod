/*
================================================================================
檔案代號:zco_file
檔案名稱:员工自订BackgroundJob资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table zco_file
(
zco01       varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號,(Login user name)           */
zco02       varchar2(20) NOT NULL,   /*程序名称                               */
                                     /*程式名稱                               */
zco03       varchar2(80),            /*程序运行参数                           */
                                     /*程式執行參數                           */
zco04       varchar2(2),             /*分                                     */
zco05       varchar2(2),             /*时                                     */
                                     /*時                                     */
zco06       varchar2(2),             /*日                                     */
zco07       varchar2(2),             /*月                                     */
zco08       varchar2(255),           /*星期                                   */
zco09       varchar2(80),            /*Action                                 */
                                     /*Action ex:mail -s 'list' a@dsc.com<< out*/
zco10       varchar2(1),             /*Active 否                              */
                                     /*Active 否(Y/N)                         */
zco11       varchar2(10)             /*营运中心编号                           */
                                     /*Plant No.                              */
);

alter table zco_file add  constraint zco_pk primary key  (zco01,zco02) enable validate;
grant select on zco_file to tiptopgp;
grant update on zco_file to tiptopgp;
grant delete on zco_file to tiptopgp;
grant insert on zco_file to tiptopgp;
grant index on zco_file to public;
grant select on zco_file to ods;
