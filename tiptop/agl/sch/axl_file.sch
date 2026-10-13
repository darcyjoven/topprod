/*
================================================================================
檔案代號:axl_file
檔案名稱:股东权益群组表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axl_file
(
axl01       varchar2(10) NOT NULL,   /*群组代码                               */
axl02       varchar2(80),            /*说明                                   */
axl03       varchar2(1),             /*No Use                                 */
                                     /*Variation Classification               */
                                     /*1.Capital 2.Capital Deposit 3.Legal Rest Deposit*/
                                     /*4.Unset Rest 5.Accumulated Conversion Adjust Qty*/
                                     /*6.Unputative Pension Cost Dead Loss    */
                                     /*7.Minority stock                       */
axl04       varchar2(1),             /*No Use                                 */
axl05       varchar2(1),             /*No Use                                 */
axl06       varchar2(1),             /*No Use                                 */
axl07       varchar2(1),             /*No Use                                 */
axl08       varchar2(1)              /*No Use                                 */
);

alter table axl_file add  constraint axl_pk primary key  (axl01) enable validate;
grant select on axl_file to tiptopgp;
grant update on axl_file to tiptopgp;
grant delete on axl_file to tiptopgp;
grant insert on axl_file to tiptopgp;
grant index on axl_file to public;
grant select on axl_file to ods;
