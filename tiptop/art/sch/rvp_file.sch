/*
================================================================================
檔案代號:rvp_file
檔案名稱:分货调整单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvp_file
(
rvp01       varchar2(20) DEFAULT ' ' NOT NULL, /*分货调整单号*/
rvp02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rvp03       varchar2(20),            /*分货单号                               */
rvp04       number(5),               /*分货项次                               */
rvp05       number(15,3),            /*分货量                                 */
rvp06       varchar2(1),             /*调整方式                               */
                                     /*Adjusted Method 1.Add 2.Reduce 3.Fixed */
rvp07       number(15,3),            /*调整量                                 */
rvplegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvpplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rvp_file add  constraint rvp_pk primary key  (rvp01,rvp02) enable validate;
grant select on rvp_file to tiptopgp;
grant update on rvp_file to tiptopgp;
grant delete on rvp_file to tiptopgp;
grant insert on rvp_file to tiptopgp;
grant index on rvp_file to public;
grant select on rvp_file to ods;
