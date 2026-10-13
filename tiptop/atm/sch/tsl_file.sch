/*
================================================================================
檔案代號:tsl_file
檔案名稱:集团集团调拨申请单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsl_file
(
tsl01       varchar2(20) NOT NULL,   /*调拨单号                               */
                                     /*Transfer Note# tsk01                   */
tsl02       number(5) NOT NULL,      /*项次                                   */
tsl03       varchar2(40),            /*料件编号                               */
tsl04       varchar2(4),             /*单位                                   */
tsl05       number(20,6),            /*数量                                   */
tsl06       number(20,6),            /*回报数量                               */
tsl07       varchar2(4),             /*单位一                                 */
tsl08       number(20,8),            /*单位一转换率                           */
tsl09       number(15,3),            /*单位一数量                             */
tsl10       varchar2(4),             /*单位二                                 */
tsl11       number(20,8),            /*单位二转换率                           */
tsl12       number(15,3),            /*单位二数量                             */
tsl13       number(5),               /*来源项次                               */
tslplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tsl_file add  constraint tsl_pk primary key  (tsl01,tsl02) enable validate;
grant select on tsl_file to tiptopgp;
grant update on tsl_file to tiptopgp;
grant delete on tsl_file to tiptopgp;
grant insert on tsl_file to tiptopgp;
grant index on tsl_file to public;
grant select on tsl_file to ods;
