/*
================================================================================
檔案代號:adi_file
檔案名稱:集团拨入单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table adi_file
(
adi01       varchar2(20) NOT NULL,   /*拨入单号                               */
adi02       number(5) NOT NULL,      /*项次                                   */
adi03       varchar2(20),            /*拨出单号                               */
adi04       number(5),               /*拨出项次                               */
adi05       varchar2(40),            /*料件编号                               */
adi06       varchar2(10),            /*拨入仓库                               */
adi07       varchar2(10),            /*库位                                   */
adi08       varchar2(24),            /*批号                                   */
adi09       varchar2(4),             /*单位                                   */
adi10       number(15,3),            /*拨入数量                               */
adi11       varchar2(1),             /*调拨计价方式                           */
adi12       number(9,4),             /*调拨百分比                             */
adi13       number(20,6),            /*拨入单价                               */
adi14       number(20,6),            /*拨入金额                               */
adi15       varchar2(20),            /*参考单号                               */
adi16       number(5),               /*参考项次                               */
adi17       number(15,3),            /*仓退数量                               */
adi18       varchar2(1),             /*计划期别格式                           */
adi19       number(10),              /*起始期别                               */
adi20       number(5),               /*序号                                   */
adi21       varchar2(1),             /*No Use                                 */
adi22       varchar2(1),             /*No Use                                 */
adi23       varchar2(1),             /*No Use                                 */
adi30       varchar2(4),             /*单位一                                 */
adi31       number(20,8),            /*单位一转换率(与库存单位)               */
adi32       number(15,3),            /*单位一数量                             */
adi33       varchar2(4),             /*单位二                                 */
adi34       number(20,8),            /*单位二转换率(与库存单位)               */
adi35       number(15,3),            /*单位二数量                             */
adiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index adi_02 on adi_file (adi03,adi04);
alter table adi_file add  constraint adi_pk primary key  (adi01,adi02) enable validate;
grant select on adi_file to tiptopgp;
grant update on adi_file to tiptopgp;
grant delete on adi_file to tiptopgp;
grant insert on adi_file to tiptopgp;
grant index on adi_file to public;
grant select on adi_file to ods;
