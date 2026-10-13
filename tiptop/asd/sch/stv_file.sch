/*
================================================================================
檔案代號:stv_file
檔案名稱:每月工单分摊基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table stv_file
(
stv01       number(5) NOT NULL,      /*年度                                   */
stv02       number(5) NOT NULL,      /*月份                                   */
stv03       varchar2(20) NOT NULL,   /*工单号码                               */
                                     /*工單號碼                               */
stv04       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
stv05       number(15,3),            /*总投入人工小时                         */
                                     /*總投入人工小時                         */
stv06       number(15,3),            /*总投入机器小时                         */
                                     /*總投入機器小時                         */
stv07       number(15,3),            /*入库数量                               */
                                     /*入庫數量                               */
stv08       varchar2(1),             /*成品否                                 */
stv09       varchar2(10),            /*产品别                                 */
                                     /*產品別                                 */
stv10       varchar2(10)             /*部门                                   */
                                     /*部門別                                 */
);

alter table stv_file add  constraint stv_pk primary key  (stv01,stv02,stv03) enable validate;
grant select on stv_file to tiptopgp;
grant update on stv_file to tiptopgp;
grant delete on stv_file to tiptopgp;
grant insert on stv_file to tiptopgp;
grant index on stv_file to public;
grant select on stv_file to ods;
