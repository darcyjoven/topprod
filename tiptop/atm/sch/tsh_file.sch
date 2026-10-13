/*
================================================================================
檔案代號:tsh_file
檔案名稱:集团调拨申请单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsh_file
(
tsh01       varchar2(20) NOT NULL,   /*调拨单号                               */
                                     /*Transfer Note# tse01                   */
tsh02       number(5) NOT NULL,      /*项次                                   */
tsh03       varchar2(40),            /*料件编号                               */
tsh04       varchar2(4),             /*单位                                   */
tsh05       number(20,6),            /*数量                                   */
tsh06       number(20,6),            /*核准数量                               */
tsh07       varchar2(4),             /*单位一                                 */
tsh08       number(20,8),            /*单位一转换率                           */
tsh09       number(15,3),            /*单位一数量                             */
tsh10       varchar2(4),             /*单位二                                 */
tsh11       number(20,8),            /*单位二转换率                           */
tsh12       number(15,3),            /*单位二数量                             */
tsh13       varchar2(10),            /*原因码                                 */
tshplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tshlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tsh_file add  constraint tsh_pk primary key  (tsh01,tsh02) enable validate;
grant select on tsh_file to tiptopgp;
grant update on tsh_file to tiptopgp;
grant delete on tsh_file to tiptopgp;
grant insert on tsh_file to tiptopgp;
grant index on tsh_file to public;
grant select on tsh_file to ods;
