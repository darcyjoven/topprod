/*
================================================================================
檔案代號:wsf_file
檔案名稱:easyflow 集成设置档(单身档设置)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsf_file
(
wsf01       varchar2(20) NOT NULL,   /*程序编号                               */
wsf02       number(5) NOT NULL,      /*单身档项次                             */
wsf03       varchar2(15) NOT NULL,   /*程序使用单身档                         */
wsf04       varchar2(20) NOT NULL,   /*单身档 key 值字段 #1                   */
wsf05       varchar2(20),            /*单身档 key 值字段 #2                   */
wsf06       varchar2(20),            /*单身档 key 值字段 #3                   */
wsf07       varchar2(20),            /*单身档 key 值字段 #4                   */
wsf08       varchar2(20),            /*单身档 key 值字段 #5                   */
wsf09       varchar2(20),            /*单身档状态码字段                       */
wsf10       varchar2(10),            /*No Use                                 */
wsf11       varchar2(10),            /*No Use                                 */
wsf12       varchar2(10),            /*No Use                                 */
wsf13       varchar2(10),            /*No Use                                 */
wsf14       varchar2(10),            /*No Use                                 */
wsf15       varchar2(10)             /*No Use                                 */
);

alter table wsf_file add  constraint wsf_pk primary key  (wsf01,wsf02) enable validate;
grant select on wsf_file to tiptopgp;
grant update on wsf_file to tiptopgp;
grant delete on wsf_file to tiptopgp;
grant insert on wsf_file to tiptopgp;
grant index on wsf_file to public;
grant select on wsf_file to ods;
