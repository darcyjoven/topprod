/*
================================================================================
檔案代號:bgo_file
檔案名稱:资本支出预算档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgo_file
(
bgo01       varchar2(10) NOT NULL,   /*版本                                   */
bgo02       varchar2(80) NOT NULL,   /*设备名称                               */
                                     /*設備名稱                               */
bgo03       varchar2(10) NOT NULL,   /*主类型编号                             */
                                     /*主類別編號                             */
bgo032      varchar2(1),             /*分摊方式                               */
                                     /*分攤方式                               */
                                     /*1.單一部門分攤                         */
                                     /*2.多部門分攤                           */
bgo033      varchar2(10),            /*分摊部门/分摊类型                      */
                                     /*分攤部門/分攤類別                      */
bgo06       number(5) NOT NULL,      /*年度　　　　                           */
bgo07       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
bgo08       number(20,6),            /*单价                                   */
                                     /*單價                                   */
bgo09       number(15,3),            /*数量                                   */
                                     /*數量                                   */
bgo10       number(20,6),            /*金额                                   */
                                     /*金額                                   */
bgo11       varchar2(1)              /*No Use                                 */
);

alter table bgo_file add  constraint bgo_pk primary key  (bgo01,bgo02,bgo03,bgo06,bgo07) enable validate;
grant select on bgo_file to tiptopgp;
grant update on bgo_file to tiptopgp;
grant delete on bgo_file to tiptopgp;
grant insert on bgo_file to tiptopgp;
grant index on bgo_file to public;
grant select on bgo_file to ods;
