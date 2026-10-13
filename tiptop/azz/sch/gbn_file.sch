/*
================================================================================
檔案代號:gbn_file
檔案名稱:查询条件纪录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbn_file
(
gbn01       number(10) NOT NULL,     /*QBE序号                                */
gbn02       number(10) NOT NULL,     /*条件序号                               */
gbn03       varchar2(30),            /*字段代码                               */
gbn04       varchar2(255),           /*条件值                                 */
gbn05       varchar2(1),             /*是否转换为系统日期                     */
gbn06       varchar2(1),             /*是否转换为系统日期第一天               */
gbn07       varchar2(1),             /*是否转换为系统日期最后一天             */
gbn08       varchar2(1),             /*以系统日期计算方法                     */
gbn09       number(5)                /*计算天数                               */
);

alter table gbn_file add  constraint gbn_pk primary key  (gbn01,gbn02) enable validate;
grant select on gbn_file to tiptopgp;
grant update on gbn_file to tiptopgp;
grant delete on gbn_file to tiptopgp;
grant insert on gbn_file to tiptopgp;
grant index on gbn_file to public;
grant select on gbn_file to ods;
