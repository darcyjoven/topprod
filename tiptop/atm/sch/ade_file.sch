/*
================================================================================
檔案代號:ade_file
檔案名稱:集团调拨申请单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ade_file
(
ade01       varchar2(20) NOT NULL,   /*调拨申请单号                           */
ade02       number(5) NOT NULL,      /*项次                                   */
ade03       varchar2(40),            /*产品编号                               */
ade04       varchar2(4),             /*单位                                   */
ade05       number(15,3),            /*数量                                   */
ade06       varchar2(10),            /*需求营运中心                           */
ade07       varchar2(10),            /*拨入仓库                               */
ade08       date,                    /*需求日期                               */
ade09       date,                    /*回复日期                               */
ade10       date,                    /*预计调拨日期                           */
ade11       varchar2(4),             /*特别注记                               */
ade12       number(15,3),            /*已调拨数量                             */
ade13       varchar2(1),             /*结案否                                 */
ade14       date,                    /*结案日期                               */
ade15       number(15,3),            /*已拨入数量                             */
ade16       varchar2(20),            /*异动单号                               */
ade17       number(5),               /*项次                                   */
ade18       varchar2(1),             /*计划期别格式                           */
ade19       number(10),              /*起始期别                               */
ade20       number(5),               /*序号                                   */
ade21       varchar2(1),             /*No                                     */
ade22       varchar2(1),             /*No                                     */
ade23       varchar2(1),             /*No                                     */
ade30       varchar2(4),             /*单位一                                 */
ade31       number(20,8),            /*单位一转换率(与库存单位)               */
ade32       number(15,3),            /*单位一数量                             */
ade33       varchar2(4),             /*单位二                                 */
ade34       number(20,8),            /*单位二转换率(与库存单位)               */
ade35       number(15,3),            /*单位二数量                             */
adeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ade_file add  constraint ade_pk primary key  (ade01,ade02) enable validate;
grant select on ade_file to tiptopgp;
grant update on ade_file to tiptopgp;
grant delete on ade_file to tiptopgp;
grant insert on ade_file to tiptopgp;
grant index on ade_file to public;
grant select on ade_file to ods;
