/*
================================================================================
檔案代號:adg_file
檔案名稱:集团拨出单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table adg_file
(
adg01       varchar2(20) NOT NULL,   /*拨出单号                               */
adg02       number(5) NOT NULL,      /*拨出单项次                             */
adg03       varchar2(20),            /*申请单号                               */
adg04       number(5),               /*申请项次                               */
adg05       varchar2(40),            /*料件编号                               */
adg06       varchar2(10),            /*仓库编号                               */
adg07       varchar2(10),            /*库位                                   */
adg08       varchar2(24),            /*批号                                   */
adg09       varchar2(10),            /*拨入营运中心编号                       */
adg10       varchar2(10),            /*拨入营运中心仓库                       */
adg11       varchar2(4),             /*单位                                   */
adg12       number(15,3),            /*拨出数量                               */
adg13       varchar2(1),             /*调拨计价方式                           */
adg14       number(9,4),             /*调拨百分比                             */
adg15       number(20,6),            /*拨出单价                               */
adg16       number(20,6),            /*拨出金额                               */
adg17       number(15,3),            /*已拨入数量                             */
adg18       varchar2(1),             /*计划期别格式                           */
adg19       number(10),              /*起始期别                               */
adg20       number(5),               /*序号                                   */
adg21       varchar2(1),             /*No Use                                 */
adg22       varchar2(1),             /*No Use                                 */
adg23       varchar2(1),             /*No Use                                 */
adg30       varchar2(4),             /*单位一                                 */
adg31       number(20,8),            /*单位一转换率(与库存单位)               */
adg32       number(15,3),            /*单位一数量                             */
adg33       varchar2(4),             /*单位二                                 */
adg34       number(20,8),            /*单位二转换率(与库存单位)               */
adg35       number(15,3),            /*单位二数量                             */
adgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index adg_02 on adg_file (adg03,adg04);
alter table adg_file add  constraint adg_pk primary key  (adg01,adg02) enable validate;
grant select on adg_file to tiptopgp;
grant update on adg_file to tiptopgp;
grant delete on adg_file to tiptopgp;
grant insert on adg_file to tiptopgp;
grant index on adg_file to public;
grant select on adg_file to ods;
