/*
================================================================================
檔案代號:obd_file
檔案名稱:集团间销售预测单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table obd_file
(
obd01       varchar2(40) NOT NULL,   /*料件编号                               */
obd02       varchar2(1) NOT NULL,    /*计划期别格式                           */
obd021      number(10) NOT NULL,     /*起始期别                               */
obd03       number(5) NOT NULL,      /*序号                                   */
obd04       number(10),              /*计划期别                               */
obd05       varchar2(1),             /*No Use                                 */
obd06       number(20,6),            /*单价                                   */
obd07       number(20,6),            /*金额                                   */
obd08       number(15,3),            /*本阶需求量                             */
obd09       number(15,3),            /*本阶调整量                             */
obd10       number(15,3),            /*下阶需求量                             */
obd11       number(15,3),            /*下阶调整量                             */
obd12       number(15,3),            /*小计                                   */
obd13       varchar2(1),             /*No                                     */
obd14       varchar2(1),             /*No                                     */
obdconf     varchar2(1),             /*审核                                   */
obdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
obdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table obd_file add  constraint obd_pk primary key  (obd01,obd02,obd021,obd03) enable validate;
grant select on obd_file to tiptopgp;
grant update on obd_file to tiptopgp;
grant delete on obd_file to tiptopgp;
grant insert on obd_file to tiptopgp;
grant index on obd_file to public;
grant select on obd_file to ods;
